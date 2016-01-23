//
//  SlackConnection.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class SlackConnection {
    
    private var state: SlackConnectionState
    private var delay: NSTimeInterval = 0
    private let token: String
    
    var onEvent: (String -> Void)?
    
    internal init(token: String) {
        self.token = token
        
        self.state = WaitingState(token: token)
        moveToState(self.state)
    }
    
    private func moveToState(newState: SlackConnectionState) {
        NSLog("Entering \(newState)")
        
        newState.onExit = { [unowned self] oldState, nextState in
            NSLog("Exiting \(oldState)")
            self.moveToState(nextState)
        }
        
        // configure the new state based on its kind
        if let wait = newState as? WaitingState {
            // every time we try to connect, we'll first wait one second longer than we did last time
            // this is a very very rudimentary backoff
            wait.delay = delay
            delay = delay + 1
        } else if let socket = newState as? WebSocketState {
            socket.onEvent = onEvent
        }
        
        self.state = newState
        self.state.enter()
    }
    
}
