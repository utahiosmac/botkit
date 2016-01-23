//
//  WaitingState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class WaitingState: SlackConnectionState {
    
    var onExit: ((old: SlackConnectionState, new: SlackConnectionState) -> Void)?
    private let token: String
    var delay: NSTimeInterval = 0
    
    init(token: String) {
        self.token = token
    }
    
    func enter() {
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        let nextState = RetrieveSocketURLState(token: token)
        let handler = { onExit(old: self, new: nextState) }
        
        if delay > 0 {
            let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(when, dispatch_get_global_queue(0, 0), handler);
        } else {
            handler()
        }
    }
    
}
