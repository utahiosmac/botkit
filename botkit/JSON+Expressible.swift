//
//  JSON+Expressible.swift
//  botkit
//
//  Created by Dave DeLong on 10/19/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

extension JSON: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self = .string(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .string(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self = .string(value)
    }
    
}

extension JSON: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = .number(Double(value))
    }
    
}

extension JSON: ExpressibleByFloatLiteral {
 
    public init(floatLiteral value: Double) {
        self = .number(value)
    }

}

extension JSON: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, JSON)...) {
        let object = Dictionary(elements)
        self = .object(object)
    }
    
}

extension JSON: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
    
}

extension JSON: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self = .boolean(value)
    }
    
}

extension JSON: ExpressibleByNilLiteral {

    public init(nilLiteral: ()) {
        self = .null
    }
}
