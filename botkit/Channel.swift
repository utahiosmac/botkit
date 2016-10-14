//
//  Channel.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Channel: Hashable, CustomStringConvertible {
    public static func ==(lhs: Channel, rhs: Channel) -> Bool { return lhs.identifier == rhs.identifier }
    public var hashValue: Int { return identifier.hashValue }
    
    public let identifier: Identifier<Channel>
    public let name: String?
    
    public var description: String {
        return "#" + (name ?? identifier.value)
    }
}

extension Channel: JSONInitializable {
    
    public init(json: JSON) throws {
        if let s = json.string {
            self.identifier = Identifier(s)
            self.name = nil
        } else if let d = json.object {
            self.identifier = try json.value(for: "id")
            self.name = d["name"]?.string
        } else {
            throw JSONError("Unable to create Channel from JSON")
        }
    }
    
}
