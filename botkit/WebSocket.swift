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
    private var receivedLastPong = true
    
    internal var onEvent: (String -> Void)?
    internal var onClose: (NSError? -> Void)?
    
    private let timerSource: dispatch_source_t
    
    init(socketURL: NSURL) {
        socket = SRWebSocket(URL: socketURL)
        timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        
        super.init()
        socket.delegate = self
    }
    
    deinit {
        dispatch_source_cancel(timerSource)
    }
    
    func open() {
        socket.open()
    }
}

extension WebSocket: SRWebSocketDelegate {
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        let pingInterval = 5.0
        let intervalInNSec = Int64(pingInterval * Double(NSEC_PER_SEC))
        let startTime = dispatch_time(DISPATCH_TIME_NOW, intervalInNSec)
        
        dispatch_source_set_timer(timerSource, startTime, UInt64(intervalInNSec), NSEC_PER_SEC / 10)
        dispatch_source_set_event_handler(timerSource) { [unowned self] in
            if self.receivedLastPong == false {
                // we did not receive the last pong
                self.socket.close()
            } else {
                // we got a pong recently
                // send another ping
                self.receivedLastPong = false
                self.socket.sendPing(nil)
            }
        }
        dispatch_resume(timerSource)
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceivePong pongPayload: NSData!) {
        self.receivedLastPong = true
    }
    
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
        dispatch_suspend(timerSource)
    }
}
