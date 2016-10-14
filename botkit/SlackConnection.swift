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
    private var delay: TimeInterval = 0
    private let configuration: Bot.Configuration
    
    private let onEvent: (String) -> Void
    
    internal init(configuration: Bot.Configuration, eventHandler: @escaping (String) -> Void) {
        self.configuration = configuration
        self.onEvent = eventHandler
        
        self.state = WaitingState(configuration: configuration)
        moveToState(self.state)
    }
    
    private func moveToState(_ newState: SlackConnectionState) {
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
