//
//  Result.swift
//  botkit
//
//  Created by Dave DeLong on 10/6/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum Result<T> {
    
    case value(T)
    case error(Error)
    
    public var value: T? {
        guard case .value(let v) = self else { return nil }
        return v
    }
    
    public var error: Error? {
        guard case .error(let e) = self else { return nil }
        return e
    }
    
    public var isValue: Bool { return value != nil }
    public var isError: Bool { return error != nil }
    
}
