//
//  Bot.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum RuleDisposition {
    case skip
    case handle
    case handleAndAbort
}

public final class Bot {
    private let connection: SlackConnection
    private let ruleController = RuleController()
    
    public init(authorizationToken: String) {
        let rules = ruleController
        let configuration = SlackConnectionConfiguration(token: authorizationToken)
        connection = SlackConnection(configuration: configuration)
        connection.onEvent = { rules.process(event: $0) }
        
        on { (e: Channel.Archived) in
            print("Archived: \(e.channel)")
        }
        
        on { (e: Channel.UserLeft) in
            print("User left \(e.channel): \(e.user)")
        }
        
        on { (e: Channel.UserJoined) in
            print("User joined \(e.channel): \(e.user)")
        }
        
        on { (e: Channel.MessagePosted) in
            let s = "In \(e.message.channel), \(e.message.user) said: \(e.message.text)"
            print(s)
        }
    }
    
    
    public func skip<T: EventType>(_ bogus: T? = nil) {
        let rule = Rule<T>(when: { (foo: T) in return .handleAndAbort },
                           action: { _, c in c() })
        
        ruleController.add(skipRule: rule)
    }
    
    public func on<T: EventType>(_ action: (T) -> Void) {
        self.on(when: { _ in return .handle }, action: action)
    }
    
    public func on<T: EventType>(when: (T) -> RuleDisposition, action: (T) -> Void) {
        let rule = Rule<T>(when: when, action: { e, c in
            action(e)
            c()
        })
        ruleController.add(rule: rule)
    }
    
}
