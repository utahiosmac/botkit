//
//  JSONInitializable.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol JSONInitializable {
    init(json: JSON) throws
}

public extension JSON {
    
    func value<T: JSONInitializable>(for key: String) throws -> T {
        guard let dict = self.object else { throw JSONError(message: "Value is not an object") }
        return try T.init(json: dict[key] ?? .unknown)
    }
    
    func value<T: JSONInitializable>(for key: String) throws -> Array<T> {
        guard let dict = self.object else { throw JSONError(message: "Value is not an object") }
        guard let arr = dict[key]?.array else { throw JSONError(message: "Value for key \"\(key)\" not an array") }
        return try arr.map { try T.init(json: $0) }
    }
    
    
    func value<T: JSONInitializable>(at index: Int) throws -> T {
        guard let arr = self.array else { throw JSONError(message: "Value is not an array") }
        guard index >= 0 && index < arr.count else { throw JSONError(message: "Index \(index) is out of bounds") }
        return try T.init(json: arr[index])
    }
    
    func value<T: JSONInitializable>(at index: Int) throws -> Array<T> {
        guard let arr = self.array else { throw JSONError(message: "Value is not an array") }
        guard index >= 0 && index < arr.count else { throw JSONError(message: "Index \(index) is out of bounds") }
        guard let subArr = arr[index].array else { throw JSONError(message: "Value at index \(index) is not an array") }
        return try subArr.map { try T.init(json: $0) }
    }
    
}

extension URL: JSONInitializable {
    public init(json: JSON) throws {
        if let s = json.string {
            guard let u = URL(string: s) else {
                throw JSONError(message: "Unable to create URL from JSON")
            }
            self = u
        } else {
            throw JSONError(message: "Unable to create URL from JSON")
        }
    }
}

extension String: JSONInitializable {
    public init(json: JSON) throws {
        if let s = json.string {
            self = s
        } else {
            throw JSONError(message: "Unable to create String from JSON")
        }
    }
}
