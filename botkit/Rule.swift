//
//  Rule.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal protocol RuleType {
    
    var help: String? { get }
    func handle(event: JSON, from: Bot, completion: () -> Void) -> RuleDisposition
    
}

internal struct Rule<T: EventType>: RuleType {
    
    let help: String?
    let when: (T) -> RuleDisposition
    let action: (T, () -> Void) -> Void
    
    init(help: String? = nil, when: @escaping (T) -> RuleDisposition, action: @escaping (T, () -> Void) -> Void) {
        self.help = help
        self.when = when
        self.action = action
    }
    
    func handle(event: JSON, from bot: Bot, completion: () -> Void) -> RuleDisposition {
        guard let builtEvent = try? T.init(json: event, bot: bot) else {
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
