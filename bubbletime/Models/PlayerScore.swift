//
//  Score.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 2/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import Foundation

struct PlayerScore : Encodable, Decodable {
    var name: String
    var score: Int
}
