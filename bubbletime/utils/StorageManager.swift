//
//  Storage Manager.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 3/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import Foundation

struct StorageManager {
    
    // Fields
    let playerScoresArchive: URL
    let gameSettingsArchive: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        playerScoresArchive = documentsDirectory.appendingPathComponent("player_scores")
            .appendingPathExtension("json")
        gameSettingsArchive = documentsDirectory.appendingPathComponent("game_settings")
            .appendingPathExtension("json")
    }
    
    func save(scores: [PlayerScore]) throws {
        do {
            let data = try JSONEncoder().encode(scores)
            try data.write(to: playerScoresArchive, options: .noFileProtection)
        }
        catch {
            throw DataAccessError.valueNotSaved
        }
    }
    
    func loadScores() throws -> [PlayerScore] {
        if let scoresData = try? Data(contentsOf: playerScoresArchive),
            let scores = try? JSONDecoder().decode([PlayerScore].self, from: scoresData) {
            return scores
        }
        throw DataAccessError.valueNotFound
    }
}

enum DataAccessError: Error {
    case valueNotFound
    case valueNotSaved
}
