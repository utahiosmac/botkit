//
//  BasicSlackEvent.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Channel {

    public struct Created: StandardEventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "channel_created")
            channel = try json.value(for: "channel")
            user = try json["channel"].value(for: "creator")
        }
    }

    public struct Deleted: StandardEventType {
        public let channel: Channel
        
        public init(json: JSON) throws {
            try json.match(type: "channel_deleted")
            channel = try json.value(for: "channel")
        }
    }

    public struct Renamed: StandardEventType {
        public let channel: Channel
        
        public init(json: JSON) throws {
            try json.match(type: "channel_renamed")
            channel = try json.value(for: "channel")
        }
    }

    public struct Archived: StandardEventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "channel_archive")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }

    public struct Unarchived: StandardEventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "channel_unarchive")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct PurposeChanged: StandardEventType {
        public let channel: Channel
        public let user: User
        public let purpose: String
        
        public init(json: JSON) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_purpose")
            
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
            purpose = try json.value(for: "purpose")
        }
    }
    
    public struct TopicChanged: StandardEventType {
        public let channel: Channel
        public let user: User
        public let topic: String
        
        public init(json: JSON) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_topic")
            
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
            topic = try json.value(for: "topic")
        }
    }
    
    public struct UserJoined: StandardEventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_join")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct UserLeft: StandardEventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_leave")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct MessagePosted: StandardEventType {
        public let message: Message
        
        public init(json: JSON) throws {
            try json.match(type: "message")
            guard json["subtype"].isUnknown else { throw JSONError(message: "Event type is a specialized Message") }
            
            message = try Message(json: json)
        }
    }
}
