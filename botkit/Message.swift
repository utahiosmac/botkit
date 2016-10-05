//
//  Message.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct Message {
    
    public let channel: Channel
    public let inChannelIdentifier: Identifier<Message>
    
    public let user: User
    public let text: String
    
}
