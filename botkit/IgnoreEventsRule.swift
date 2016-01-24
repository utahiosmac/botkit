//
//  IgnoreEventsRule.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal struct IgnoreEventsRule: Rule {
    private let events: Set<SlackEventType>
    
    init(_ eventTypes: SlackEventType ...) {
        events = Set(eventTypes)
    }
    
    func dispositionForEvent(event: SlackEvent) -> RuleDisposition {
        return events.contains(event.eventType) ? .HandleAndAbort : .Skip
    }
    func executeActionForEvent(event: SlackEvent, completion: Void -> Void) {
        NSLog("Ignoring \(event.eventType.rawValue)")
        completion()
    }
    
}
