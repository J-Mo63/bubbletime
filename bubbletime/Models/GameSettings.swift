//
//  GameSettings.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 3/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import Foundation

// A model struct for the game settings
struct GameSettings : Encodable, Decodable {
    var maxPongs: Int = 15
    var gameTime: Int = 1
    
    func gameTimeValue() -> Int {
        switch gameTime {
        case 0:
            return 30
        case 1:
            return 60
        case 2:
            return 120
        default:
            return 60
        }
    }
}
