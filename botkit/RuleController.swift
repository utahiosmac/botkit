//
//  RuleController.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class RuleController {
    private let defaultRules = Array<Rule>()
    private var externalRules = Array<Rule>()
    
    private enum RuleAction {
        case Abort
        case Continue
    }
    
    init() { }
    
    internal func processEvent(event: SlackEvent) {
        let action = sendEvent(event, toRules: defaultRules, waitUntilDone: true)
        if action == .Continue {
            sendEvent(event, toRules: externalRules, waitUntilDone: false)
        }
    }
    
    private func sendEvent(event: SlackEvent, toRules rules: Array<Rule>, waitUntilDone: Bool) -> RuleAction {
        var ruleAction = RuleAction.Continue
        for rule in rules {
            ruleAction = sendEvent(event, toRule: rule, waitUntilDone: waitUntilDone)
            if ruleAction == .Abort { break }
        }
        return ruleAction
    }
    
    private func sendEvent(event: SlackEvent, toRule rule: Rule, waitUntilDone: Bool) -> RuleAction {
        guard event.eventType == rule.triggeringEvent else { return .Continue }
        
        let notifyOfCompletion: Void -> Void
        let waitUntilCompletion: Void -> Void
        
        if waitUntilDone {
            let sem = dispatch_semaphore_create(0)
            notifyOfCompletion = { dispatch_semaphore_signal(sem) }
            waitUntilCompletion = { dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER) }
        } else {
            notifyOfCompletion = { }
            waitUntilCompletion = { }
        }
        
        let disposition = rule.condition(event)
        
        // this rule does not match
        // return false to indicate that this rule does not abort rule execution
        if disposition == .Skip { return .Continue }
        
        // this rule matches; execute its action
        rule.action(event, notifyOfCompletion)
        waitUntilCompletion()
        
        // if waitUntilDone is false, then we will likely return here before the rule has finished executing its action
        // that's ok, because we've already indicated that we don't need other rules to execute
        return (disposition == .HandleAndAbort) ? .Abort : .Continue
    }
    
}
