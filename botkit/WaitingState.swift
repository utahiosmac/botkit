//
//  WaitingState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class WaitingState: SlackConnectionState {
    
    var onExit: ((_ old: SlackConnectionState, _ new: SlackConnectionState) -> Void)?
    private let configuration: Bot.Configuration
    var delay: TimeInterval = 0
    
    init(configuration: Bot.Configuration) {
        self.configuration = configuration
    }
    
    func enter() {
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        let nextState = RetrieveSocketURLState(configuration: configuration)
        let handler = { onExit(self, nextState) }
        
        if delay > 0 {
            let when = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.global().asyncAfter(deadline: when, execute: handler);
        } else {
            handler()
        }
    }
    
}
