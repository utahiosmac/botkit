//
//  BasicSlackEvent.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Channel {

    public struct Created: EventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_created")
            channel = try json.value(for: "channel")
            user = try json["channel"].value(for: "creator")
        }
    }

    public struct Deleted: EventType {
        public let channel: Channel
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_deleted")
            channel = try json.value(for: "channel")
        }
    }

    public struct Renamed: EventType {
        public let channel: Channel
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_renamed")
            channel = try json.value(for: "channel")
        }
    }

    public struct Archived: EventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_archive")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }

    public struct Unarchived: EventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_unarchive")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct PurposeChanged: EventType {
        public let channel: Channel
        public let user: User
        public let purpose: String
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_purpose")
            
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
            purpose = try json.value(for: "purpose")
        }
    }
    
    public struct TopicChanged: EventType {
        public let channel: Channel
        public let user: User
        public let topic: String
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_topic")
            
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
            topic = try json.value(for: "topic")
        }
    }
    
    public struct UserJoined: EventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_join")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct UserLeft: EventType {
        public let channel: Channel
        public let user: User
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            try json.match(subtype: "channel_leave")
            channel = try json.value(for: "channel")
            user = try json.value(for: "user")
        }
    }
    
    public struct Joined: EventType {
        public let channel: Channel
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_joined")
            channel = try json.value(for: "channel")
        }
    }
    
    public struct Left: EventType {
        public let channel: Channel
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "channel_left")
            channel = try json.value(for: "channel")
        }
    }
    
    public struct MessagePosted: EventType {
        public let message: Message
        
        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            guard json["subtype"].isUnknown else { throw JSONError("Event type is a specialized Message") }
            
            message = try Message(json: json)
        }
    }
    
    public struct SnippetPosted: EventType {
        public let channel: Channel
        public let file: File

        public init(json: JSON, bot: Bot) throws {
            try json.match(type: "message")
            try json.match(subtype: "file_share")
            
            try file = json.value(for: "file")
            try channel = json.value(for: "channel")
        }
    }
}
