//
//  WebSocket.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation
import SocketRocket

internal class WebSocket: NSObject {
    private var socket: SRWebSocket
    private var socketError: NSError?
    
    internal var onEvent: (String -> Void)?
    internal var onClose: (NSError? -> Void)?
    
    init(socketURL: NSURL) {
        socket = SRWebSocket(URL: socketURL)
        super.init()
        socket.delegate = self
    }
    
    func open() {
        socket.open()
    }
}

extension WebSocket: SRWebSocketDelegate {
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // messages from the socket can either be NSData or NSString
        // we don't particularly care about data messages
        guard let string = message as? String else { return }
        onEvent?(string)
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        // if this gets called, then we'll also get the "didCloseWithCode"
        // save the error we get here so it can be inspected in the didCloseWithCode: method
        socketError = error
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        // maybe boo?
        onClose?(socketError)
    }
}
