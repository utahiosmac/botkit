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
    public let filename: String
    public let mimetype: String
    public let downloadURL: URL
    
    public init(json: JSON) throws {
        identifier = try json.value(for: "id")
        filename = try json.value(for: "name")
        mimetype = try json.value(for: "mimetype")
        
        let urlAsString: String = try json.value(for: "url_private_download")
        guard let url = URL(string: urlAsString) else {
            throw JSONError("`url_private_download` is expected to be a valid URL")
        }
        
        downloadURL = url
    }
    
}
