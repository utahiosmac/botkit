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
    private let configuration: Configuration
    private let connection: SlackConnection
    private let ruleController = RuleController()
    
    public init(configuration: Configuration) {
        let rules = ruleController
        self.configuration = configuration
        connection = SlackConnection(configuration: configuration)
        connection.onEvent = { rules.process(event: $0) }
    }
    
    
    public func skip<T: EventType>(_ bogus: T? = nil) {
        let rule = Rule<T>(when: { (foo: T) in return .handleAndAbort },
                           action: { _, c in c() })
        
        ruleController.add(skipRule: rule)
    }
    
    public func on<T: EventType>(_ action: @escaping (T, Bot) -> Void) {
        self.on(when: { _ in return .handle }, action: action)
    }
    
    public func on<T: EventType>(when: @escaping (T) -> RuleDisposition, action: @escaping (T, Bot) -> Void) {
        let rule = Rule<T>(when: when, action: { [weak self] e, c in
            defer { c() }
            guard let bot = self else { return }
            action(e, bot)
        })
        ruleController.add(rule: rule)
    }
    
    public func execute<A: SlackActionType>(action: A, asAdmin: Bool = false, completion: @escaping (Result<A.ResponseType>) -> Void) {
        let token = asAdmin ? configuration.adminToken : configuration.authToken
        
        var c = URLComponents()
        c.scheme = "https"
        c.host = "slack.com"
        c.path = "/api/\(action.method)"
        c.queryItems = [URLQueryItem(name: "token", value: token)]
        
        guard let url = c.url else {
            fatalError("Unable to construct URL for action \(action)")
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.error(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
                completion(.error(error))
                return
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let error = NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: ["response": httpResponse])
                completion(.error(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorZeroByteResource, userInfo: nil)
                completion(.error(error))
                return
            }
            
            guard let json = try? JSON(data: data) else {
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: nil)
                completion(.error(error))
                return
            }
            
            guard json["ok"].bool == true else {
                let message = json["error"].string ?? "Unknown Slack API Error"
                let error = NSError(domain: "Slack", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.error(error))
                return
            }
            
            do {
                let response = try A.ResponseType.init(json: json)
                completion(.value(response))
            } catch let e {
                completion(.error(e))
            }
        }
        
        task.resume()
    }
    
}
