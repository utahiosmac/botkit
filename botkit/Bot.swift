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
    private let configuration: SlackConnectionConfiguration
    private let connection: SlackConnection
    private let ruleController = RuleController()
    
    public init(authorizationToken: String) {
        let rules = ruleController
        configuration = SlackConnectionConfiguration(token: authorizationToken)
        connection = SlackConnection(configuration: configuration)
        connection.onEvent = { rules.process(event: $0) }
    }
    
    
    public func skip<T: EventType>(_ bogus: T? = nil) {
        let rule = Rule<T>(when: { (foo: T) in return .handleAndAbort },
                           action: { _, c in c() })
        
        ruleController.add(skipRule: rule)
    }
    
    public func on<T: EventType>(_ action: @escaping (T, Bot) -> Void) {
        self.on(when: { _ in return .handle }, action: action)
    }
    
    public func on<T: EventType>(when: @escaping (T) -> RuleDisposition, action: @escaping (T, Bot) -> Void) {
        let rule = Rule<T>(when: when, action: { [weak self] e, c in
            defer { c() }
            guard let bot = self else { return }
            action(e, bot)
        })
        ruleController.add(rule: rule)
    }
    
    public func execute(action: SlackMethodType) {
        
    }
    
}
