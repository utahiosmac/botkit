//
//  Channel+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/7/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Channel {
    
    public struct List: SlackActionType {
        public typealias ResponseType = Array<Channel>
        
        public let method = "channels.list"
        
        public init() { }
        
        public func constructResponse(json: JSON) throws -> Array<Channel> {
            return try json.value(for: "channels")
        }
    }
    
    public struct Info: SlackActionType {
        public typealias ResponseType = Channel
        public let method = "channels.info"
        public let parameters: Array<URLQueryItem>
        
        public init(channel: String) {
            parameters = [URLQueryItem(name: "channel", value: channel)]
        }
    }
    
    public struct ListMembers: SlackActionType {
        public typealias ResponseType = Array<User>
        public let method = "channels.info"
        public let parameters: Array<URLQueryItem>
        
        public init(channel: String) {
            parameters = [URLQueryItem(name: "channel", value: channel)]
        }
        
        public func constructResponse(json: JSON) throws -> Array<User> {
            return try json["channel"].value(for: "members")
        }
    }
    
    public struct PostMessage: SlackActionType {
        public typealias ResponseType = Message

        public let method = "chat.postMessage"
        public let httpMethod: HTTP.Method = .post
        public let parameters: Array<URLQueryItem>
        
        public init(channel: Channel, message: String, as name: String = "help") {
            self.init(channel: channel.identifier.value, message: message, as: name)
        }
        
        public init(channel: Identifier<Channel>, message: String, as name: String = "help", ephemeral: Bool = false) {
            self.init(channel: channel.value, message: message, as: name)
        }
        
        public init(channel: String, message: String, as name: String = "help", ephemeral: Bool = false) {
            parameters = [
                URLQueryItem(name: "channel", value: channel),
                URLQueryItem(name: "text", value: message),
                URLQueryItem(name: "parse", value: "full"),
                URLQueryItem(name: "username", value: name),
                URLQueryItem(name: "as_user", value: "false"),
                URLQueryItem(name: "link_names", value: "1"),
                URLQueryItem(name: "response_type", value: ephemeral ? "ephemeral" : "in_channel")
            ]
        }
        
    }
    
    public func send(message: String) -> PostMessage {
        return PostMessage(channel: self, message: message)
    }
    
    public func listMembers() -> ListMembers {
        return ListMembers(channel: identifier.value)
    }
}
