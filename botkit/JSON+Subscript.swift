//
//  JSON+Subscript.swift
//  botkit
//
//  Created by Dave DeLong on 10/19/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

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
