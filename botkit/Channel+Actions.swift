//
//  Channel+Actions.swift
//  botkit
//
//  Created by Dave DeLong on 10/7/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension Channel {
    
    public struct PostMessage: SlackActionType {
        public typealias ResponseType = Message

        public let method = "chat.postMessage"
        public let httpMethod = "POST"
        public let parameters: Array<URLQueryItem>
        
        public init(channel: Channel, message: String) {
            parameters = [
                URLQueryItem(name: "channel", value: channel.identifier.value),
                URLQueryItem(name: "text", value: message),
                URLQueryItem(name: "parse", value: "full"),
                URLQueryItem(name: "link_names", value: "1")
            ]
        }
        
    }
    
    
}
