//
//  BasicSlackEvent.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal struct BasicSlackEvent: SlackEvent {
    internal let eventType: SlackEventType
    internal let payload: Dictionary<String, AnyObject>
    
    init?(payload: Dictionary<String, AnyObject>) {
        guard let type = payload[SlackResponseKeys.type] as? String else { return nil }
        guard let eventType = SlackEventType(rawValue: type) else { return nil }
        
        self.payload = payload
        self.eventType = eventType
    }
    
    init?(jsonString: String) {
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        
        let rawJSON: AnyObject
        do {
            rawJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        } catch _ { return nil }
        
        guard let payload = rawJSON as? Dictionary<String, AnyObject> else { return nil }
        self.init(payload: payload)
    }
    
}
