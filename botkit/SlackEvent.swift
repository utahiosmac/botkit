//
//  EventType.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol SlackEvent {
    
    var eventType: SlackEventType { get }
    var payload: Dictionary<String, AnyObject> { get }
    
    init?(payload: Dictionary<String, AnyObject>)
    
}
