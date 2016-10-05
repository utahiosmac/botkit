//
//  Emoji+Events.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Emoji {

    public struct Added: StandardEventType {
        public let emoji: Emoji
        
        public init(json: JSON) throws {
            try json.match(type: "emoji_changed")
            try json.match(subtype: "add")
            
            emoji = try Emoji(json: json)
        }
    }

    public struct Removed: StandardEventType {
        public let names: Array<String>
        
        public init(json: JSON) throws {
            try json.match(type: "emoji_changed")
            try json.match(subtype: "remove")
            
            names = try json.value(for: "names")
        }
    }

}
