//
//  JSON+Values.swift
//  botkit
//
//  Created by Dave DeLong on 10/19/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

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
