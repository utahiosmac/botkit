//
//  Collection.swift
//  botkit
//
//  Created by Dave DeLong on 10/7/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Collection {
    
    func keyedBy<T: Hashable>(_ keyer: (Iterator.Element) -> T?) -> Dictionary<T, Iterator.Element> {
        var d = Dictionary<T, Iterator.Element>()
        for item in self {
            if let key = keyer(item) {
                d[key] = item
            }
        }
        return d
    }
    
    func keyedBy<T: Hashable>(_ keyer: (Iterator.Element) -> Array<T>) -> Dictionary<T, Iterator.Element> {
        var d = Dictionary<T, Iterator.Element>()
        for item in self {
            let keys = keyer(item)
            for key in keys {
                d[key] = item
            }
        }
        return d
    }
}

public extension Collection where Iterator.Element: Hashable {
    
    func unique() -> Array<Iterator.Element> {
        var uniqued = Array<Iterator.Element>()
        var soFar = Set<Iterator.Element>()
        for item in self {
            if soFar.contains(item) == false {
                uniqued.append(item)
                soFar.insert(item)
            }
        }
        return uniqued
    }
    
}
