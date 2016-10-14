//
//  User+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/7/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension User {
    
    public struct MyInfo: SlackActionType {
        public typealias ResponseType = User
        public let method = "auth.test"
        public let responseKey: String? = "user_id"
        
        public init() { }
    }
    
    public struct List: SlackActionType {
        public typealias ResponseType = Array<User>
        public let method = "users.list"
        
        public init() { }
        
        public func constructResponse(json: JSON) throws -> Array<User> {
            return try json.value(for: "members")
        }
    }
    
    public struct Info: SlackActionType {
        public typealias ResponseType = User
        public let method = "users.info"
        public let responseKey: String? = "user"
        public let parameters: Array<URLQueryItem>
        
        public init(user: String) {
            parameters = [URLQueryItem(name: "user", value: user)]
        }
    }
    
    public struct StartChat: SlackActionType {
        public typealias ResponseType = Channel
        public let method = "im.open"
        public let responseKey: String? = "channel"
        public let parameters: Array<URLQueryItem>
        
        public init(user: User) {
            parameters = [
                URLQueryItem(name: "user", value: user.identifier.value),
                URLQueryItem(name: "return_im", value: "false")
            ]
        }
        
        public init(user: Identifier<User>) {
            parameters = [
                URLQueryItem(name: "user", value: user.value),
                URLQueryItem(name: "return_im", value: "false")
            ]
        }
    }
    
    public func startChat() -> StartChat {
        return StartChat(user: self)
    }
    
}
