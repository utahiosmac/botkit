//
//  SlackConnectionConfiguration.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal struct SlackConnectionConfiguration {
    let token: String
    let pingInterval: TimeInterval
    
    init(token: String, pingInterval: TimeInterval = 5) {
        self.token = token
        self.pingInterval = max(pingInterval, 5)
    }
}
