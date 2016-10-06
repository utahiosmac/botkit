//
//  BotConfiguration.swift
//  botkit
//
//  Created by Dave DeLong on 10/6/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Bot {
    
    public struct Configuration {
        
        public let authToken: String
        public let adminToken: String?
        public let pingInterval: TimeInterval
        public let dataDirectory: URL
        
        public init(authToken: String, adminToken: String? = nil, pingInterval: TimeInterval = 5, dataDirectory: URL) {
            self.authToken = authToken
            self.adminToken = adminToken
            self.pingInterval = max(pingInterval, 5)
            self.dataDirectory = dataDirectory
        }
        
    }
    
}
