//
//  Dictionary.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal extension Dictionary {
    
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
    
}
