//
//  SettingsController.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 4/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // Fields
    let storageManager = StorageManager()
    
    // Outlets
    @IBOutlet weak var maxPongsSlider: UISlider!
    @IBOutlet weak var maxPongsLabel: UILabel!
    @IBOutlet weak var gameLengthSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the font of the segmented control
        let fontAttribute = NSDictionary(object: UIFont(name: "BadWrite_Full", size: 20)!, forKey: NSAttributedStringKey.font as NSCopying)
        gameLengthSegment.setTitleTextAttributes(fontAttribute as? [AnyHashable : Any], for: .normal)
        
        do {
            // Attempt to fetch and display the game settings
            let gameSettings = try storageManager.loadSettings()
            maxPongsSlider.value = Float(gameSettings.maxPongs)
            gameLengthSegment.selectedSegmentIndex = gameSettings.gameTime
        }
        catch {
            // Use the defaults
            let gameSetting = GameSettings()
            maxPongsSlider.value = Float(gameSetting.maxPongs)
            gameLengthSegment.selectedSegmentIndex = gameSetting.gameTime
        }
        
        // Manually update pong number text
        maxPongsChanged(self)
    }
    
    @IBAction func maxPongsChanged(_ sender: Any) {
        // Update the pong number text
        maxPongsLabel.text = String(Int(maxPongsSlider.value))
    }
    
    func handleError() {
        showGeneralErrorMessage(in: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save the settings
        let settings = GameSettings(maxPongs: Int(maxPongsSlider.value), gameTime: gameLengthSegment.selectedSegmentIndex)
        do {
            try storageManager.save(settings: settings)
        }
        catch {
            handleError()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "homeFromSettingsSegue", sender: self)
    }
}
