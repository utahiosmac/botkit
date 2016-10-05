//
//  EventType.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol EventType {
    init?(event: String)
}





public protocol StandardEventType: EventType, JSONInitializable {
    
}

public extension StandardEventType {
    
    init?(event: String) {
        guard let data = event.data(using: .utf8) else { return nil }
        guard let json = try? JSON(data) else { return nil }
        do {
            try self.init(json: json)
        } catch _ {
            return nil
        }
    }
    
}

public extension JSON {
    
    func match(type: String) throws {
        if self["type"].string != type {
            throw JSONError(message: "Event type is not \(type)")
        }
    }
    
    func match(subtype: String) throws {
        if self["subtype"].string != subtype {
            throw JSONError(message: "Event subtype is not \(subtype)")
        }
    }
}
