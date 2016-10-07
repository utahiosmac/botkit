//
//  Team+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/6/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Team {
    
    public struct Info: SlackActionType {
        public typealias ResponseType = Team
        public let responseKey = "team"
        
        public let method = "team.info"
        public init() { }
        
    }
    
}
