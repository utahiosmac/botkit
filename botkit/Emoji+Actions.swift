//
//  Emoji+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Emoji {
 
    public struct List: SlackActionType {
        public typealias ResponseType = Array<Emoji>
        
        public let method = "emoji.list"
        
        public init() { }
        
        public func constructResponse(json: JSON) throws -> ResponseType {
            let definitions = json["emoji"].object ?? [:]
            return try Array(definitions).map { try Emoji(name: $0.0, value: $0.1) }
        }
        
    }
    
}
