//
//  SlackConnectionState.swift
//  botkit
//
//  Created by Dave DeLong on 1/23/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

internal protocol SlackConnectionState: class {
    var onExit: ((old: SlackConnectionState, new: SlackConnectionState) -> Void)? { get set }
    func enter()
}
