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
        public typealias ResponseType = Response
        
        public let method = "emoji.list"
        
        public init() { }
        
        public struct Response: SlackResponseType {
            public let emoji: Array<Emoji>
            
            public init(json: JSON) throws {
                let definitions = json["emoji"].object
                let built = (try definitions?.map { (k, v) -> (String, Emoji) in
                    let j = JSON.object(["name": .string(k), "value": v])
                    let e = try Emoji(json: j)
                    return (k, e)
                }) ?? [:]
                
                emoji = Array(built.values)
            }
        }
        
    }
    
}
