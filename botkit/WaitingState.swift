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
    private let configuration: SlackConnectionConfiguration
    var delay: TimeInterval = 0
    
    init(configuration: SlackConnectionConfiguration) {
        self.configuration = configuration
    }
    
    func enter() {
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        let nextState = RetrieveSocketURLState(configuration: configuration)
        let handler = { onExit(old: self, new: nextState) }
        
        if delay > 0 {
            let when = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.global().asyncAfter(deadline: when, execute: handler);
        } else {
            handler()
        }
    }
    
}
