//
//  File.swift
//  botkit
//
//  Created by Derrick Hathaway on 10/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation


public final class File: JSONInitializable {
    
    public let identifier: Identifier<File>
    public let name: String?
    
    public init(json: JSON) throws {
        identifier = try json.value(for: "id")
        name = try? json.value(for: "name")
    }
    
}
