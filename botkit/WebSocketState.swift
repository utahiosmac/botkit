//
//  WebSocketState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class WebSocketState: SlackConnectionState {
    
    private let configuration: SlackConnectionConfiguration
    private let socket: WebSocket
    
    var onExit: ((_ old: SlackConnectionState, _ new: SlackConnectionState) -> Void)?
    var onEvent: ((String) -> Void)?
    
    init(configuration: SlackConnectionConfiguration, socketURL: URL) {
        self.configuration = configuration
        self.socket = WebSocket(socketURL: socketURL, pingInterval: configuration.pingInterval)
    }
    
    func enter() {
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        socket.onEvent = onEvent
        
        let configuration = self.configuration
        socket.onClose = { [unowned self] error in
            NSLog("Closing socket (error: %@)", error ?? "none")
            onExit(self, WaitingState(configuration: configuration))
        }
        
        socket.open()
    }
    
}
