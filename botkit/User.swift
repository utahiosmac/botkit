//
//  User.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct User: Hashable, CustomStringConvertible, JSONInitializable {
    public static func ==(lhs: User, rhs: User) -> Bool { return lhs.identifier == rhs.identifier }
    public var hashValue: Int { return identifier.hashValue }
    
    public let identifier: Identifier<User>
    public let name: String?
    
    public var description: String { return "@" + (name ?? identifier.value) }
    
    public init(json: JSON) throws {
        if let s = json.string {
            self.identifier = Identifier(s)
            self.name = nil
        } else if json.isObject {
            self.identifier = try json.value(for: "id")
            self.name = try? json.value(for: "name")
        } else {
            throw JSONError(message: "Unable to create User from JSON")
        }
    }
}

