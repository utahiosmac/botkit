//
//  Startup.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Startup: StandardEventType {
    
    public init(json: JSON) throws {
        try json.match(type: "hello")
    }
    
}
