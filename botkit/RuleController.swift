//
//  RuleController.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class RuleController {
    private enum RuleAction {
        case abort
        case `continue`
    }
    
    private var skips = Array<RuleType>()
    private var rules = Array<RuleType>()
    
    init() {
    
    }
    
    internal func process(event: String) {
        let rulesCopy = rules
        for rule in rulesCopy {
            let ruleAction = send(event: event, to: rule, waitUntilDone: false)
            if ruleAction == .abort { break }
        }
    }
    
    internal func skip<T: EventType>(_ bogus: T? = nil) {
        let rule = Rule<T>(when: { (foo: T) in return .handleAndAbort },
                           action: { _, c in c() })
        skips.append(rule)
    }
    
    internal func on<T: EventType>(do: (T) -> Void) {
        self.on(when: { _ in return .handle }, action: `do`)
    }
    
    internal func on<T: EventType>(when: (T) -> RuleDisposition, action: (T) -> Void) {
        let rule = Rule<T>(when: when, action: { e, c in
            action(e)
            c()
        })
        rules.append(rule)
    }
    
    private func send(event: String, to rule: RuleType, waitUntilDone: Bool) -> RuleAction {
        let notifyOfCompletion: (Void) -> Void
        let waitUntilCompletion: (Void) -> Void
        
        if waitUntilDone {
            let sem = DispatchSemaphore(value: 0)
            notifyOfCompletion = { sem.signal() }
            waitUntilCompletion = { sem.wait(timeout: DispatchTime.distantFuture) }
        } else {
            notifyOfCompletion = { }
            waitUntilCompletion = { }
        }
        
        let disposition = rule.handle(event: event, completion: notifyOfCompletion)
        waitUntilCompletion()
        
        // if waitUntilDone is false, then we will likely return here before the rule has finished executing its action
        // that's ok, because we've already indicated that we don't need other rules to execute
        return (disposition == .handleAndAbort) ? .abort : .continue
        
    }
    
    /*
    private let defaultRules: Array<Rule>
    private var externalRules = Array<Rule>()
    
    
    init() {
        defaultRules = [
//            IgnoreEventsRule(.UserTyping, .PresenceChange, .ManualPresenceChange)
        ]
    
    }
    
    internal func processEvent(_ event: SlackEvent) {
        let action = sendEvent(event, toRules: defaultRules, waitUntilDone: true)
        if action == .continue {
            sendEvent(event, toRules: externalRules, waitUntilDone: false)
        }
    }
    
    private func sendEvent(_ event: SlackEvent, toRules rules: Array<Rule>, waitUntilDone: Bool) -> RuleAction {
        var ruleAction = RuleAction.continue
        for rule in rules {
            ruleAction = sendEvent(event, toRule: rule, waitUntilDone: waitUntilDone)
            if ruleAction == .abort { break }
        }
        return ruleAction
    }
    
    private func sendEvent(_ event: SlackEvent, toRule rule: Rule, waitUntilDone: Bool) -> RuleAction {
        let notifyOfCompletion: (Void) -> Void
        let waitUntilCompletion: (Void) -> Void
        
        if waitUntilDone {
            let sem = DispatchSemaphore(value: 0)
            notifyOfCompletion = { sem.signal() }
            waitUntilCompletion = { sem.wait(timeout: DispatchTime.distantFuture) }
        } else {
            notifyOfCompletion = { }
            waitUntilCompletion = { }
        }
        
        let disposition = rule.dispositionForEvent(event)
        
        // this rule does not match
        // return false to indicate that this rule does not abort rule execution
        if disposition == .skip { return .continue }
        
        // this rule matches; execute its action
        rule.executeActionForEvent(event, completion: notifyOfCompletion)
        waitUntilCompletion()
        
        // if waitUntilDone is false, then we will likely return here before the rule has finished executing its action
        // that's ok, because we've already indicated that we don't need other rules to execute
        return (disposition == .handleAndAbort) ? .abort : .continue
    }
    */
}
