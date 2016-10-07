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
    
}
