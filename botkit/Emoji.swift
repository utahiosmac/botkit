//
//  Emoji.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Emoji: JSONInitializable {
    public enum Value: JSONInitializable {
        case image(URL)
        case alias(String)
        
        public init(json: JSON) throws {
            let s = try String(json: json)
            if s.hasPrefix("alias:") {
                let index = s.index(s.startIndex, offsetBy: 6)
                self = .alias(s.substring(from: index))
            } else {
                self = .image(try URL(json: json))
            }
        }
    }
    
    public let name: String
    public let value: Value
    
    public init(json: JSON) throws {
        self.name = try json.value(for: "name")
        self.value = try json.value(for: "value")
    }
    
    public init(name: String, value: JSON) throws {
        self.name = name
        self.value = try Value(json: value)
    }
}
