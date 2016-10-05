//
//  SlackMethodType.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol SlackMethodType {
    var method: String { get }
    func requestBody() -> Dictionary<String, AnyObject>
}
