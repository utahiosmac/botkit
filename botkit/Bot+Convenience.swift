//
//  Bot+Convenience.swift
//  botkit
//
//  Created by Dave DeLong on 10/7/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Bot {
    func report(_ message: String, in channel: String = "#help-status") {
        post(message, in: channel)
    }
}

public extension Bot {
    
    func listUsers(completion: @escaping (Result<Array<User>>) -> Void) {
        execute(action: User.List(), completion: completion)
    }
    
    func send(_ message: String, to user: String, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        let matches = userCache.users(matching: user)
        guard let match = matches.first?.value else {
            completion(.error(NSError(domain: "Slack", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot find user \(user)"])))
            return
        }
        
        send(message, to: match, completion: completion)
    }
    
    func send(_ message: String, to user: User, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        send(message, to: user.identifier, completion: completion)
    }
    
    func send(_ message: String, to user: Identifier<User>, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        let action = User.StartChat(user: user)
        execute(action: action) { r1 in
            switch r1 {
                case .error(let e): completion(.error(e))
                case .value(let channel):
                    self.execute(action: channel.send(message: message), completion: completion)
            }
        }
    }
    
    func react(to message: Message, with emoji: String) {
        execute(action: message.add(reaction: emoji), completion: { _ in })
    }
    
    func reply(to message: Message, with text: String, ephemeral: Bool = false) {
        let name = self.name(for: message.user)
        let response = "@\(name) \(text)"
        post(response, in: message.channel, ephemeral: ephemeral)
    }
    
}

public extension Bot {
    
    func listChannels(completion: @escaping (Result<Array<Channel>>) -> Void) {
        execute(action: Channel.List(), completion: completion)
    }
    
    func post(_ message: String, in channel: String, ephemeral: Bool = false, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        let action = Channel.PostMessage(channel: channel, message: message, ephemeral: ephemeral)
        execute(action: action, completion: completion)
    }
    
    func post(_ message: String, in channel: Channel, ephemeral: Bool = false, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        post(message, in: channel.identifier.value, ephemeral: ephemeral, completion: completion)
    }
    
    func post(_ message: String, in channel: Identifier<Channel>, ephemeral: Bool = false, completion: @escaping (Result<Message>) -> Void = { _ in }) {
        post(message, in: channel.value, ephemeral: ephemeral, completion: completion)
    }
    
}

public extension Bot {
    
    func listChannelMembers(channel: String, completion: @escaping (Result<Array<User>>) -> Void) {
        execute(action: Channel.ListMembers(channel: channel), completion: completion)
    }
    
}
