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
    
    internal func helps() -> Array<String> {
        return rules.flatMap { $0.help }
    }
    
    internal func add(skipRule: RuleType) {
        skips.append(skipRule)
    }
    
    internal func add(rule: RuleType) {
        rules.append(rule)
    }
    
    internal func process(event: String, from bot: Bot) {
        guard let data = event.data(using: .utf8) else { return }
        guard let json = try? JSON(data: data) else { return }
        guard json.isUnknown == false else {
            print("Unable to create JSON from \(event)")
            return
        }
        
        let action = send(event: json, to: skips, from: bot, waitUntilDone: true)
        if action == .continue {
            _ = send(event: json, to: rules, from: bot, waitUntilDone: false)
        }
    }
    
    private func send(event: JSON, to rules: Array<RuleType>, from bot: Bot, waitUntilDone: Bool) -> RuleAction {
        for rule in rules {
            let ruleAction = send(event: event, to: rule, from: bot, waitUntilDone: waitUntilDone)
            if ruleAction == .abort { return .abort }
        }
        return .continue
    }
    
    private func send(event: JSON, to rule: RuleType, from bot: Bot, waitUntilDone: Bool) -> RuleAction {
        let notifyOfCompletion: (Void) -> Void
        let waitUntilCompletion: (Void) -> Void
        
        if waitUntilDone {
            let sem = DispatchSemaphore(value: 0)
            notifyOfCompletion = { sem.signal() }
            waitUntilCompletion = { _ = sem.wait(timeout: DispatchTime.distantFuture) }
        } else {
            notifyOfCompletion = { }
            waitUntilCompletion = { }
        }
        
        let disposition = rule.handle(event: event, from: bot, completion: notifyOfCompletion)
        waitUntilCompletion()
        
        // if waitUntilDone is false, then we will likely return here before the rule has finished executing its action
        // that's ok, because we've already indicated that we don't need other rules to execute
        return (disposition == .handleAndAbort) ? .abort : .continue
    }
    
}
