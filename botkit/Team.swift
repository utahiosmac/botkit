//
//  Team.swift
//  botkit
//
//  Created by Dave DeLong on 10/5/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public final class Team: JSONInitializable {
    
    public let identifier: Identifier<Team>
    public let name: String?
    
    public init(json: JSON) throws {
        identifier = try json.value(for: "id")
        name = try? json.value(for: "name")
    }
    
}
