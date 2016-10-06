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
    fileprivate var socket: SRWebSocket
    fileprivate var socketError: NSError?
    fileprivate var receivedLastPong = true
    
    internal var onEvent: ((String) -> Void)?
    internal var onClose: ((NSError?) -> Void)?
    
    fileprivate let timerSource: DispatchSourceTimer
    fileprivate let pingInterval: TimeInterval
    
    init(socketURL: URL, pingInterval: TimeInterval) {
        self.socket = SRWebSocket(url: socketURL)
        self.pingInterval = pingInterval
        self.timerSource = DispatchSource.makeTimerSource(flags: [], queue: .main)
        
        super.init()
        socket.delegate = self
    }
    
    func open() {
        socket.open()
    }
    
    fileprivate func close() {
        socket.delegate = nil
        timerSource.cancel()
        onClose?(socketError)
    }
}

extension WebSocket: SRWebSocketDelegate {
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        let intervalInNSec = pingInterval * Double(NSEC_PER_SEC)
        let startTime = DispatchTime.now() + Double(intervalInNSec) / Double(NSEC_PER_SEC)
        
        timerSource.scheduleRepeating(deadline: startTime, interval: pingInterval, leeway: .nanoseconds(Int(NSEC_PER_SEC / 10)))
        timerSource.setEventHandler { [unowned self] in
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
                try? self.socket.sendPing(nil)
            }
        }
        timerSource.resume()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        self.receivedLastPong = true
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // messages from the socket can either be NSData or NSString
        // we don't particularly care about data messages
        guard let string = message as? String else { return }
        onEvent?(string)
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        // save the error we can pass it back through the onClose closure
        socketError = error
        close()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        // tear it all down
        close()
    }
}
