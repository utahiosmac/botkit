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
    
    internal func add(skipRule: RuleType) {
        skips.append(skipRule)
    }
    
    internal func add(rule: RuleType) {
        rules.append(rule)
    }
    
    internal func process(event: String) {
        let action = send(event: event, to: skips, waitUntilDone: true)
        if action == .continue {
            _ = send(event: event, to: rules, waitUntilDone: false)
        }
    }
    
    private func send(event: String, to rules: Array<RuleType>, waitUntilDone: Bool) -> RuleAction {
        for rule in rules {
            let ruleAction = send(event: event, to: rule, waitUntilDone: waitUntilDone)
            if ruleAction == .abort { return .abort }
        }
        return .continue
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
}
