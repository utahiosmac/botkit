//
//  Rule.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum RuleDisposition {
    case Skip
    case Handle
    case HandleAndAbort
}

public protocol Rule {
    func dispositionForEvent(event: SlackEvent) -> RuleDisposition
    func executeActionForEvent(event: SlackEvent, completion: Void -> Void)
}
