//
//  JSONInitializable.swift
//  botkit
//
//  Created by Dave DeLong on 10/4/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public protocol JSONInitializable {
    init(json: JSON) throws
}

extension Bool: JSONInitializable {
    public init(json: JSON) throws {
        guard let b = json.bool else {
            throw JSONError("Unable to create Bool from JSON")
        }
        self = b
    }
}

extension Int: JSONInitializable {
    public init(json: JSON) throws {
        guard let n = json.number else {
            throw JSONError("Unable to create Int from JSON")
        }
        self = Int(n)
    }
}

extension Double: JSONInitializable {
    public init(json: JSON) throws {
        guard let n = json.number else {
            throw JSONError("Unable to create Double from JSON")
        }
        self = n
    }
}

extension String: JSONInitializable {
    public init(json: JSON) throws {
        if let s = json.string {
            self = s
        } else {
            throw JSONError("Unable to create String from JSON")
        }
    }
}

extension URL: JSONInitializable {
    public init(json: JSON) throws {
        if let s = json.string {
            guard let u = URL(string: s) else {
                throw JSONError("Unable to create URL from JSON")
            }
            self = u
        } else {
            throw JSONError("Unable to create URL from JSON")
        }
    }
}
