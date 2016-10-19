//
//  JSON.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum JSON {
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
                
            case let arr as Array<Any>:
                self = .array(arr.map { JSON($0) })
                
            case let dict as Dictionary<String, Any>:
                self = .object(dict.map { ($0, JSON($1)) })
                
            case _ as NSNull:
                self = .null
                
            default:
                self = .unknown
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

