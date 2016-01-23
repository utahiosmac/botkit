//
//  RetrieveSocketURLState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class RetrieveSocketURLState: SlackConnectionState {
    
    var onExit: ((old: SlackConnectionState, new: SlackConnectionState) -> Void)?
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func enter() {
        guard let url = NSURL(string: "https://slack.com/api/rtm.start?token=\(token)") else {
            fatalError("Unable to construct Slack connection URL")
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { [unowned self] data, response, error in
            self.handleResponse(data, response: response, error: error)
            
        }
        task.resume()
    }
    
    private func handleResponse(data: NSData?, response: NSURLResponse?, error: NSError?) {
        // must get the right info from the data
        // otherwise we log stuff and go back to Waiting
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        let token = self.token
        let errorHandler = { onExit(old: self, new: WaitingState(token: token)) }
        
        guard let data = data else {
            NSLog("No response data from Slack")
            if let response = response {
                NSLog("Slack response: %@", response)
            } else if let error = error {
                NSLog("Connection error: %@", error)
            }
            errorHandler()
            return
        }
        
        guard let rawJSON = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
            NSLog("Unable to decode response data as JSON")
            errorHandler()
            return
        }
        
        guard let json = rawJSON as? Dictionary<String, AnyObject> else {
            NSLog("JSON response is not a dictionary")
            errorHandler()
            return
        }
        
        guard let rawSocketURL = json["url"] as? String else {
            NSLog("JSON response does not contain a URL string")
            errorHandler()
            return
        }
        
        guard let socketURL = NSURL(string: rawSocketURL) else {
            NSLog("Socket URL is not a valid URL")
            errorHandler()
            return
        }
        
        let nextState = WebSocketState(token: token, socketURL: socketURL)
        onExit(old: self, new: nextState)
    }
}
