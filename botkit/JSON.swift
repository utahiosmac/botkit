//
//  JSON.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum JSON: Equatable {
    case unknown
    case null
    case string(String)
    case number(Double)
    case boolean(Bool)
    case array(Array<JSON>)
    case object(Dictionary<String, JSON>)
}

public extension JSON {
    init(_ value: String?) {
        if let str = value {
            self = .string(str)
        } else {
            self = .null
        }
    }
    
    init(_ value: Int?) {
        if let int = value {
            self = .number(Double(int))
        } else {
            self = .null
        }
    }
    
    init(_ value: Double?) {
        if let float = value {
            self = .number(float)
        } else {
            self = .null
        }
    }
    
    init(_ value: Dictionary<String, JSON>?) {
        if let dict = value {
            self = .object(dict)
        } else {
            self = .null
        }
    }
    
    init(_ value: Array<JSON>?) {
        if let arr = value {
            self = .array(arr)
        } else {
            self = .null
        }
    }
    
    init(_ value: Bool?) {
        if let bool = value {
            self = .boolean(bool)
        } else {
            self = .null
        }
    }
    
    init(_ value: Any) {
        
        switch value {
        case let str as String:
            self = .string(str)
            
        case let num as NSNumber:
            if String(cString: num.objCType) == "c" { //may be Bool value
                self = .boolean(num.boolValue)
            } else {
                self = .number(num.doubleValue)
            }
            
        case let arr as Array<AnyObject>:
            self = .array(arr.map { JSON($0) })
            
        case let dict as Dictionary<String, AnyObject>:
            self = .object(dict.map { ($0, JSON($1)) })
            
        case _ as NSNull:
            self = .null
            
        default:
            self = .unknown
        }
    }
    
}

// Add optional properties that represent each JSON value type
public extension JSON {
    var isUnknown: Bool { return self == .unknown }
    var isNull: Bool { return self == .null }
    var isString: Bool { return self.string != nil }
    var isNumber: Bool { return self.number != nil }
    var isObject: Bool { return self.object != nil }
    var isArray: Bool { return self.array != nil }
    var isBool: Bool { return self.bool != nil }
    
    var string: String? {
        guard case let .string(str) = self else { return nil }
        return str
    }
    
    var number: Double? {
        guard case let .number(num) = self else { return nil }
        return num
    }
    
    var object: Dictionary<String, JSON>? {
        guard case let .object(dict) = self else { return nil }
        return dict
    }
    
    var array: Array<JSON>? {
        guard case let .array(arr) = self else { return nil }
        return arr
    }
    
    var bool: Bool? {
        guard case let .boolean(b) = self else { return nil }
        return b
    }
}

// Add subscripting support
public extension JSON {
    
    subscript(key: String) -> JSON {
        get {
            if let dict = self.object {
                return dict[key] ?? .unknown
            } else {
                return .unknown
            }
        }
        set {
            if var dict = self.object {
                dict[key] = newValue
                self = .object(dict)
            }
            
        }
    }
    
    subscript(index: Int) -> JSON {
        get {
            if let arr = self.array {
                if index >= 0 && index < arr.count {
                    return arr[index]
                }
            }
            return .unknown
        }
        set {
            if var arr = self.array {
                arr[index] = newValue
                self = .array(arr)
            }
        }
    }
}

extension JSON {
    
    public init(contentsOf url: URL, options: Data.ReadingOptions = []) throws {
        let data = try Data(contentsOf: url, options: options)
        try self.init(data: data)
    }
    
    public init(data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        self.init(object)
    }
    
    public func data(_ options: JSONSerialization.WritingOptions = []) throws -> Data {
        let o = try jsonObject()
        return try JSONSerialization.data(withJSONObject: o, options: options)
    }
    
    func jsonObject() throws -> Any {
        switch self {
            case .unknown: throw JSONError("Cannot encode an unknown JSON value")
            case .null: return NSNull()
            case .string(let s): return s
            case .number(let n): return n
            case .boolean(let b): return b
            case .array(let a): return try a.map { try $0.jsonObject() }
            case .object(let d): return try d.mapValues { try $0.jsonObject() }
        }
    }
}

// Add conformance to ExpressibleBy*Literal protocols
extension JSON: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByDictionaryLiteral, ExpressibleByArrayLiteral, ExpressibleByBooleanLiteral, ExpressibleByNilLiteral {
    
    // Requirements for ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    // Requirements for ExpressibleByIntegerLiteral and ExpressibleByFloatLiteral
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    public init(floatLiteral value: Double) {
        self.init(value)
    }
    
    // Requirement for ExpressibleByDictionaryLiteral
    public init(dictionaryLiteral elements: (String, JSON)...) {
        let named = elements.map { (key: $0.0, value: $0.1) }
        self.init(Dictionary(named))
    }
    
    // Requirement for ExpressibleByArrayLiteral
    public init(arrayLiteral elements: JSON...) {
        self.init(elements)
    }
    
    // Requirement for ExpressibleByBooleanLiteral
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
    
    // Requirement for ExpressibleByNilLiteral
    public init(nilLiteral: ()) {
        self = .null
    }
}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs, rhs) {
        case (.unknown, .unknown): return true
        case (.null, .null): return true
        case (.string(let l), .string(let r)): return l == r
        case (.number(let l), .number(let r)): return l == r
        case (.boolean(let l), .boolean(let r)): return l == r
        case (.array(let l), .array(let r)): return l == r
        case (.object(let l), .object(let r)): return l == r
        default: return false
    }
}

public func ==(lhs: JSON, rhs: Double) -> Bool {
    guard case let .number(n) = lhs else { return false }
    return n == rhs
}

public func ==(lhs: JSON, rhs: Bool) -> Bool {
    guard case let .boolean(b) = lhs else { return false }
    return b == rhs
}

public func ==(lhs: JSON, rhs: String) -> Bool {
    guard case let .string(s) = lhs else { return false }
    return s == rhs
}

public func ==(lhs: JSON, rhs: Array<JSON>) -> Bool {
    guard case let .array(a) = lhs else { return false }
    return a == rhs
}

public func ==(lhs: JSON, rhs: Dictionary<String, JSON>) -> Bool {
    guard case let .object(d) = lhs else { return false }
    return d == rhs
}

