//
//  String.swift
//  botkit
//
//  Created by Dave DeLong on 10/17/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public extension String {
    
    func removing(prefix: String, options: String.CompareOptions = []) -> String {
        guard let prefixRange = range(of: prefix, options: options) else { return self }
        return self[prefixRange.upperBound..<endIndex]
    }
    
    func removing(suffix: String, options: String.CompareOptions = []) -> String {
        var allOptions = options
        allOptions.insert(.backwards)
        guard let suffixRange = range(of: suffix, options: allOptions) else { return self }
        return self[startIndex..<suffixRange.lowerBound]
    }
    
}
