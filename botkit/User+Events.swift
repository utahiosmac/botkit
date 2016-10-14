//
//  User+Events.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension User {
    
    public struct Joined: EventType {
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "team_join")
            user = try json.value(for: "user")
        }
    }
    
    public struct Changed: EventType {
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "user_change")
            user = try json.value(for: "user")
        }
        
    }
    
}
