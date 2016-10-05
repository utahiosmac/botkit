//
//  Message.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Message: JSONInitializable {
    public let channel: Channel
    public let inChannelIdentifier: Identifier<Message>
    
    public let user: User
    public let text: String
    
    public let isEdited: Bool
    
    public init(json: JSON) throws {
        channel = try json.value(for: "channel")
        inChannelIdentifier = try json.value(for: "ts")
        
        user = try json.value(for: "user")
        text = try json.value(for: "text")
        
        isEdited = (json["edited"].isUnknown == false)
    }
    
}
