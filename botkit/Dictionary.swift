//
//  Dictionary.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    init(_ elements: Array<Element>) {
        self.init(minimumCapacity: elements.count)
        for (key, value) in elements {
            self[key] = value
        }
    }
    
    func map<NewKey: Hashable, NewValue>(_ block: (Element) throws -> (NewKey, NewValue)) rethrows -> Dictionary<NewKey, NewValue> {
        var mapped = Dictionary<NewKey, NewValue>()
        for (k, v) in self {
            let (nk, nv) = try block((k, v))
            mapped[nk] = nv
        }
        return mapped
    }
    
    func mapValues<NewValue>(_ block: (Value) throws -> NewValue) rethrows -> Dictionary<Key, NewValue> {
        return try map { try ($0, block($1)) }
    }
    
    func values(for keys: Array<Key>) -> Array<Value> {
        var final = Array<Value>()
        for key in keys {
            if let value = self[key] {
                final.append(value)
            }
        }
        return final
    }
    
}
