//
//  RetrieveSocketURLState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal class RetrieveSocketURLState: SlackConnectionState {
    
    var onExit: ((_ old: SlackConnectionState, _ new: SlackConnectionState) -> Void)?
    private let configuration: Bot.Configuration
    
    init(configuration: Bot.Configuration) {
        self.configuration = configuration
    }
    
    func enter() {
        guard let url = URL(string: "https://slack.com/api/rtm.start?token=\(configuration.authToken)") else {
            fatalError("Unable to construct Slack connection URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            self.handleResponse(data, response: response, error: error)
            
        }
        task.resume()
    }
    
    private func handleResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        // must get the right info from the data
        // otherwise we log stuff and go back to Waiting
        guard let onExit = onExit else {
            fatalError("Cannot enter state without a way to exit it")
        }
        
        let configuration = self.configuration
        let errorHandler = { onExit(self, WaitingState(configuration: configuration)) }
        
        guard let data = data else {
            NSLog("No response data from Slack")
            if let response = response {
                print("Slack response: \(response)")
            } else if let error = error {
                print("Connection error: \(error)")
            }
            errorHandler()
            return
        }
        
        guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []) else {
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
        
        guard let socketURL = URL(string: rawSocketURL) else {
            NSLog("Socket URL is not a valid URL")
            errorHandler()
            return
        }
        
        let nextState = WebSocketState(configuration: configuration, socketURL: socketURL)
        onExit(self, nextState)
    }
}
