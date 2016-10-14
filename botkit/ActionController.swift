//
//  ActionController.swift
//  botkit
//
//  Created by Dave DeLong on 10/12/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal final class ActionController {
    private let session = URLSession.shared
    private let configuration: Bot.Configuration
    
    init(configuration: Bot.Configuration) {
        self.configuration = configuration
    }
    
    func execute<A: SlackActionType>(action: A, asAdmin: Bool = false, completion: @escaping (Result<A.ResponseType>) -> Void) {
        var token = configuration.authToken
        if asAdmin == true || action.requiresAdminToken {
            guard let adminToken = configuration.adminToken else {
                let error = NSError(domain: "BotKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Action requires admin token, but no admin token was provided"])
                completion(.error(error))
                return
            }
            token = adminToken
        }
        
        var c = URLComponents()
        c.scheme = "https"
        c.host = "slack.com"
        c.path = "/api/\(action.method)"
        
        // don't allow an action to specify their own token
        let actionParameters = action.parameters.filter { $0.name != "token" }
        let allParameters = [URLQueryItem(name: "token", value: token)] + actionParameters
        
        if action.httpMethod == .get {
            c.queryItems = allParameters
        }
        
        guard let url = c.url else {
            fatalError("Unable to construct URL for action \(action)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = action.httpMethod.rawValue
        
        if action.httpMethod != .get {
            let bodyParameters = allParameters.map { q -> String in
                let k = q.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let v = q.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return k + "=" + v
            }
            let body = bodyParameters.joined(separator: "&")
            request.httpBody = body.data(using: .utf8)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.process(action: action, data: data, response: response, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    private func process<A: SlackActionType>(action: A, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<A.ResponseType>) -> Void) {
        
        var result: Result<A.ResponseType> = .error(NSError(domain: "Unknown", code: -1, userInfo: [:]))
        defer { completion(result) }
        
        if let error = error {
            result = .error(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            result = .error(NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil))
            return
        }
        
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            result = .error(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: ["response": httpResponse]))
            return
        }
        
        guard let data = data else {
            result = .error(NSError(domain: NSURLErrorDomain, code: NSURLErrorZeroByteResource, userInfo: nil))
            return
        }
        
        guard let json = try? JSON(data: data) else {
            result = .error(NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotDecodeRawData, userInfo: nil))
            return
        }
        
        guard json["ok"].bool == true else {
            let message = json["error"].string ?? "Unknown Slack API Error"
            result = .error(NSError(domain: "Slack", code: 1, userInfo: [NSLocalizedDescriptionKey: message]))
            return
        }
        
        do {
            let response = try action.constructResponse(json: json)
            result = .value(response)
        } catch let e {
            result = .error(e)
        }
    }
    
}
