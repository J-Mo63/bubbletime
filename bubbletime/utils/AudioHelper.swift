//
//  AudioHelper.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 6/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import AVFoundation
import UIKit

var player: AVAudioPlayer?

struct AudioHelper {
    
    // Fields
    let player: AVAudioPlayer
    
    init(audioTitle: String, fileExtension: String) throws {
        // Create the url for the file
        guard let loadedUrl = Bundle.main.url(forResource: audioTitle, withExtension: fileExtension) else { throw AudioError.fileNotFound }
        
        // Set up a new player
        try AVAudioSession.sharedInstance()
            .setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: loadedUrl, fileTypeHint: AVFileType.mp3.rawValue)
    }
}

// An enum of audio helper errors
enum AudioError: Error {
    case fileNotFound
}
