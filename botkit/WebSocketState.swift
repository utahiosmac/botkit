//
//  WebSocketState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class WebSocketState: SlackConnectionState {
    
    private let token: String
    private let socket: WebSocket
    
    var onExit: ((old: SlackConnectionState, new: SlackConnectionState) -> Void)?
    var onEvent: (String -> Void)?
    
    init(token: String, socketURL: NSURL) {
        self.token = token
        self.socket = WebSocket(socketURL: socketURL)
    }
    
    func enter() {
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        socket.onEvent = onEvent
        
        let token = self.token
        socket.onClose = { [unowned self] error in
            NSLog("Closing socket (error: %@)", error ?? "none")
            onExit(old: self, new: WaitingState(token: token))
        }
        
        socket.open()
    }
    
}
