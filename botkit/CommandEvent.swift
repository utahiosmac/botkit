//
//  CommandEvent.swift
//  botkit
//
//  Created by Dave DeLong on 10/19/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct CommandEvent<C: BotCommand>: EventType {
    public let command: C
    public let message: Message
    
    public init(json: JSON, bot: Bot) throws {
        let messageEvent = try Channel.MessagePosted(json: json, bot: bot)
        message = messageEvent.message
        guard let me = bot.me else { throw JSONError("No bot user") }
        
        // @help foo
        // @help: foo
        // @help : foo
        let regex = Regex(pattern: "^\\<@\(me.identifier.value)\\>\\s*:?\\s+(.+)$")
        let text = message.text
        
        guard let matches = regex.match(text) else { throw JSONError("Not addressed to me") }
        
        let commandText = matches[1]
        
        let verbMatchingText = commandText.lowercased()
        let verb = C.verb.lowercased()
        
        guard verbMatchingText.hasPrefix(verb) else { throw JSONError("Event does not have the proper verb") }
        
        let arguments = commandText.removing(prefix: C.verb, options: [.caseInsensitive])
        let trimmed = arguments.trimmingCharacters(in: .whitespacesAndNewlines)
        command = try C.init(with: trimmed, from: bot)
    }
    
}

public protocol BotCommand {
    static var verb: String { get }
    init(with text: String, from bot: Bot) throws
}
