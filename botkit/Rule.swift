//
//  Rule.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal enum RuleDisposition {
    case skip
    case handle
    case handleAndAbort
}

internal protocol RuleType {
    
    func handle(event: String, completion: () -> Void) -> RuleDisposition
    
}

internal struct Rule<T: EventType>: RuleType {
    
    let when: (T) -> RuleDisposition
    let action: (T, () -> Void) -> Void
    
    func handle(event: String, completion: () -> Void) -> RuleDisposition {
        guard let builtEvent = T.init(event: event) else {
            completion()
            return .skip
        }
        
        let disposition = when(builtEvent)
        guard disposition != .skip else {
            completion()
            return disposition
        }
        
        action(builtEvent, completion)
        return disposition
    }
    
}
