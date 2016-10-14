//
//  JSONError.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public struct JSONError: Error {
    public let message: String
    
    public init(_ message: String) {
        self.message = message
    }
}
