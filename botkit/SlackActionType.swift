//
//  SlackActionType.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol SlackActionType {
    associatedtype ResponseType
    
    var method: String { get }
    
    var httpMethod: String { get }
    var parameters: Array<URLQueryItem> { get }
    var httpBody: JSON { get }
    var requiresAdminToken: Bool { get }
    
    var responseKey: String? { get }
    func constructResponse(json: JSON) throws -> ResponseType
}

extension SlackActionType {
    public var httpMethod: String { return "GET" }
    public var parameters: Array<URLQueryItem> { return [] }
    public var httpBody: JSON { return .unknown }
    public var requiresAdminToken: Bool { return false }
    
    public var responseKey: String? { return nil }
}

extension SlackActionType where ResponseType: JSONInitializable {
    public func constructResponse(json: JSON) throws -> ResponseType {
        if let key = responseKey {
            return try json.value(for: key)
        } else {
            return try ResponseType.init(json: json)
        }
    }
}
