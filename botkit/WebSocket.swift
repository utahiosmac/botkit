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
    private let pingInterval: NSTimeInterval
    
    init(socketURL: NSURL, pingInterval: NSTimeInterval) {
        self.socket = SRWebSocket(URL: socketURL)
        self.pingInterval = pingInterval
        self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        
        super.init()
        socket.delegate = self
    }
    
    func open() {
        socket.open()
    }
    
    private func close() {
        socket.delegate = nil
        dispatch_source_cancel(timerSource)
        onClose?(socketError)
    }
}

extension WebSocket: SRWebSocketDelegate {
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        let intervalInNSec = Int64(pingInterval * Double(NSEC_PER_SEC))
        let startTime = dispatch_time(DISPATCH_TIME_NOW, intervalInNSec)
        
        dispatch_source_set_timer(timerSource, startTime, UInt64(intervalInNSec), NSEC_PER_SEC / 10)
        dispatch_source_set_event_handler(timerSource) { [unowned self] in
            if self.receivedLastPong == false {
                // we did not receive the last pong
                // abort the socket so that we can spin up a new connection
                self.socket.close()
            } else if self.socket.readyState == .CLOSED || self.socket.readyState == .CLOSING {
                self.close()
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
        // save the error we can pass it back through the onClose closure
        socketError = error
        close()
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        // tear it all down
        close()
    }
}
