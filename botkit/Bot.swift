//
//  Bot.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public class Bot {
    private let connection: SlackConnection
    private let ruleController = RuleController()
    
    public init(authorizationToken: String) {
        let rules = ruleController
        let configuration = SlackConnectionConfiguration(token: authorizationToken)
        connection = SlackConnection(configuration: configuration)
        connection.onEvent = { rules.process(event: $0) }
        
        ruleController.on(do: { (e: Channel.Archived) in
            print("Archived: \(e.channel)")
        })
        
        ruleController.on(do: { (e: Channel.UserLeft) in
            print("User left: \(e.user)")
        })
        
        ruleController.on(do: { (e: Channel.UserJoined) in
            print("User joined: \(e.user)")
        })
    }
    
}
