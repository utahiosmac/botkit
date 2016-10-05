//
//  Identifier.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Identifier<T>: Hashable, ExpressibleByStringLiteral, CustomStringConvertible, JSONInitializable {
    public let value: String
    public var hashValue: Int { return value.hashValue }
    
    public var description: String {
        return value
    }
    
    public init(_ value: String) {
        self.value = value
    }
    
    public init(json: JSON) throws {
        guard let s = json.string else { throw JSONError(message: "Value is not a string") }
        self.value = s
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
    
    public init(scalarLiteral value: String) {
        self.value = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.value = value
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.value = value
    }
    
    public static func ==<T>(lhs: Identifier<T>, rhs: Identifier<T>) -> Bool {
        return lhs.value == rhs.value
    }
}
