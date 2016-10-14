//
//  ChannelCache.swift
//  botkit
//
//  Created by Dave DeLong on 10/13/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class ChannelCache {
    fileprivate let q = DispatchQueue(label: "BotKit.ChannelCache")
    
    fileprivate let cacheFile: URL
    
    fileprivate let actionController: ActionController
    fileprivate var cache = Dictionary<String, JSON>()
    
    init(configuration: Bot.Configuration, actionController: ActionController, setupComplete: @escaping () -> Void) {
        self.actionController = actionController
        cacheFile = configuration.dataDirectory.appendingPathComponent("channels.json")
        
        self.cache = (try? JSON(contentsOf: cacheFile))?.object ?? [:]
        
        let g = DispatchGroup()
        fetchAllChannels(group: g)
        
        g.notify(queue: .main, execute: setupComplete)
    }
    
    func name(for channel: Channel) -> String {
        if let name = channel.name { return name }
        return name(for: channel.identifier)
    }
    
    func name(for channel: Identifier<Channel>) -> String {
        var name = channel.value
        q.sync {
            if let n = cache[channel.value]?.string {
                name = n
            }
        }
        return name
    }
    
    func created(channel: Channel) {
        // add the channel to a list
        update(for: channel)
    }
    
    func renamed(channel: Channel) {
        // cache the new name
        update(for: channel)
    }
    
}

extension ChannelCache {
    
    fileprivate func update(for channel: Channel) {
        if let name = channel.name {
            q.async {
                self.cache[channel.identifier.value] = .string(name)
                self.persistCache()
            }
        } else {
            fetch(channel: channel)
        }
    }
    
    fileprivate func fetch(channel: Channel) {
        
        q.async {
            let s = DispatchSemaphore(value: 0)
            
            let action = Channel.Info(channel: channel.identifier.value)
            self.actionController.execute(action: action, completion: { r in
                guard let c = r.value else { return }
                guard let name = c.name else { return }
                self.cache[c.identifier.value] = .string(name)
                self.persistCache()
                s.signal()
            })
            s.wait()
        }
    }
    
    fileprivate func fetchAllChannels(group: DispatchGroup) {
        group.enter()
        
        q.async {
            let s = DispatchSemaphore(value: 0)
            
            self.actionController.execute(action: Channel.List(), completion: { r in
                let values = r.value ?? []
                values.forEach {
                    guard let n = $0.name else { return }
                    self.cache[$0.identifier.value] = .string(n)
                }
                self.persistCache()
                s.signal()
            })
            s.wait()
            group.leave()
        }
    }
    
    fileprivate func persistCache() {
        let json = JSON.object(cache)
        
        do {
            try FileManager.default.createFile(atPath: cacheFile.path, contents: nil, attributes: nil)
            
            let data = try json.data([.prettyPrinted])
            _ = try data.write(to: cacheFile)
            print("Channel cache persisted to \(cacheFile)")
        } catch let e {
            print("Error caching channels: \(e)")
        }
        
    }
    
}
