//
//  Message+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/11/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Message {
    
    public struct AddReaction: SlackActionType {
        public typealias ResponseType = Bool
        public let method = "reactions.add"
        public let responseKey: String? = "ok"
        public let parameters: Array<URLQueryItem>
        
        public init(message: Message, emoji: String) {
            parameters = [
                URLQueryItem(name: "name", value: emoji),
                URLQueryItem(name: "channel", value: message.channel.identifier.value),
                URLQueryItem(name: "timestamp", value: message.inChannelIdentifier.value)
            ]
        }
        
    }
    
    public func add(reaction: Emoji) -> AddReaction {
        return AddReaction(message: self, emoji: reaction.name)
    }
    
    public func add(reaction: String) -> AddReaction {
        return AddReaction(message: self, emoji: reaction)
    }
}
