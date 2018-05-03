//
//  GameSettings.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 3/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import Foundation

struct GameSettings : Encodable, Decodable {
    let maxPongs: Int = 15
    var gameTime: Int = 5
}
