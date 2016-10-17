//
//  Bot.swift
//  botkit
//
//  Created by Dave DeLong on 1/22/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum RuleDisposition {
    case skip
    case handle
    case handleAndAbort
}

public final class Bot {
    public let configuration: Configuration
    private var connection: SlackConnection?
    private let ruleController = RuleController()
    private let actionController: ActionController
    
    internal let userCache: UserCache
    internal let channelCache: ChannelCache
    
    private let setupGroup = DispatchGroup()
    
    public var me: User?
    public var team: Team?
    
    public init(configuration: Configuration) {
        let g = setupGroup
        
        self.configuration = configuration
        self.actionController = ActionController(configuration: configuration)
        
        g.enter()
        let userCache = UserCache(configuration: configuration, actionController: actionController, setupComplete: { g.leave() })
        
        g.enter()
        let channelCache = ChannelCache(configuration: configuration, actionController: actionController, setupComplete: { g.leave() })
        
        self.userCache = userCache
        self.channelCache = channelCache
        
        // rules to keep the caches up-to-date
        
        // user cache
        self.on { (e: User.Changed, b: Bot) in
            userCache.userChanged(user: e.user)
        }
        
        self.on { (e: User.Joined, b: Bot) in
            userCache.userJoined(user: e.user)
        }
        
        // channel cache
        self.on { (e: Channel.Created, b: Bot) in
            channelCache.created(channel: e.channel)
        }
        
        self.on { (e: Channel.Renamed, b: Bot) in
            channelCache.renamed(channel: e.channel)
        }
    }
    
    public func connect() {
        setupGroup.notify(queue: .main) {
            let rules = self.ruleController
            self.connection = SlackConnection(configuration: self.configuration, eventHandler: { [weak self] in
                guard let strongSelf = self else { return }
                rules.process(event: $0, from: strongSelf)
            })
        }
    }
    
    
    public func skip<T: EventType>(_ bogus: T? = nil) {
        let rule = Rule<T>(when: { (foo: T) in return .handleAndAbort },
                           action: { _, c in c() })
        
        ruleController.add(skipRule: rule)
    }
    
    public func on<T: EventType>(_ help: String? = nil, _ action: @escaping (T, Bot) -> Void) {
        self.on(help: help, when: { _ in return .handle }, action: action)
    }
    
    public func on<T: EventType>(help: String? = nil, when: @escaping (T) -> RuleDisposition, action: @escaping (T, Bot) -> Void) {
        let rule = Rule<T>(help: help, when: when, action: { [weak self] e, c in
            defer { c() }
            guard let bot = self else { return }
            action(e, bot)
        })
        ruleController.add(rule: rule)
    }
    
    public func execute<A: SlackActionType>(action: A, asAdmin: Bool = false, completion: @escaping (Result<A.ResponseType>) -> Void) {
        actionController.execute(action: action, asAdmin: asAdmin, completion: completion)
    }
    
}

extension Bot {

    public func name(for user: User) -> String {
        return userCache.name(for: user)
    }
    
    public func name(for user: Identifier<User>) -> String {
        return userCache.name(for: user)
    }
    
    public func name(for channel: Channel) -> String {
        return channelCache.name(for: channel)
    }
    
    public func name(for channel: Identifier<Channel>) -> String {
        return channelCache.name(for: channel)
    }
    
}
