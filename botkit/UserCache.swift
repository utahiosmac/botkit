//
//  UserCache.swift
//  botkit
//
//  Created by Dave DeLong on 10/12/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal final class UserCache {
    private let cacheFile: URL
    
    private var cache = Dictionary<String, JSON>()
    private let q = DispatchQueue(label: "BotKit.UserCache")
    private let actionController: ActionController
    
    init(configuration: Bot.Configuration, actionController: ActionController, setupComplete: @escaping () -> Void) {
        self.actionController = actionController
        cacheFile = configuration.dataDirectory.appendingPathComponent("users.json")
        
        self.cache = (try? JSON(contentsOf: cacheFile))?.object ?? [:]
        
        fetchAllUsers(completion: setupComplete)
    }
    
    func name(for user: User) -> String {
        if let name = user.name { return name }
        return name(for: user.identifier)
    }
    
    func name(for user: Identifier<User>) -> String {
        var name = user.value
        q.sync {
            if let n = cache[user.value]?.string {
                name = n
            }
        }
        return name
    }
    
    func users(matching string: String) -> Array<Identifier<User>> {
        var matches = Array<Identifier<User>>()
        q.sync {
            cache.forEach { (key, value) in
                if key == string || value.string == string {
                    matches.append(Identifier(key))
                }
            }
        }
        return matches
    }
    
    func userJoined(user: User) {
        userChanged(user: user)
    }
    
    func userChanged(user: User) {
        if let name = user.name {
            q.async {
                self.cache[user.identifier.value] = .string(name)
                self.persistCache()
            }
        } else {
            fetch(user: user)
        }
    }
    
    private func fetchAllUsers(completion: @escaping () -> Void) {
        
        q.async {
            let s = DispatchSemaphore(value: 0)
            
            self.actionController.execute(action: User.List(), completion: { r in
                let values = r.value ?? []
                values.forEach {
                    guard let n = $0.name else { return }
                    self.cache[$0.identifier.value] = .string(n)
                }
                self.persistCache()
                s.signal()
            })
            s.wait()
            completion()
        }
    }
    
    private func fetch(user: User) {
        
        q.async {
            let s = DispatchSemaphore(value: 0)
            
            let action = User.Info(user: user.identifier.value)
            self.actionController.execute(action: action, completion: { r in
                guard let u = r.value else { return }
                guard let name = u.name else { return }
                self.cache[u.identifier.value] = .string(name)
                self.persistCache()
                s.signal()
            })
            s.wait()
        }
    }
    
    private func persistCache() {
        let json = JSON.object(cache)
        
        do {
            try FileManager.default.createFile(atPath: cacheFile.path, contents: nil, attributes: nil)
            
            let data = try json.data([.prettyPrinted])
            _ = try data.write(to: cacheFile)
            print("User cache persisted to \(cacheFile)")
        } catch let e {
            print("Error caching users: \(e)")
        }
        
    }
    
}
