//
//  SlackActionType.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol SlackResponseType: JSONInitializable {
    
}

public protocol SlackActionType {
    associatedtype ResponseType: SlackResponseType
    
    
    var method: String { get }
    func requestBody() -> Dictionary<String, Any>
}

extension SlackActionType {
    public func requestBody() -> Dictionary<String, Any> { return [:] }
}
