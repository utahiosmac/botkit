//
//  Rule.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Rule {
    
    public enum Disposition {
        case Skip
        case Handle
        case HandleAndAbort
    }
    
    public let triggeringEvent: SlackEventType
    
    public let condition: SlackEvent -> Disposition
    public let action: (SlackEvent, Void -> Void) -> Void
    
}
