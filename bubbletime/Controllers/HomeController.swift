//
//  ViewController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        // An empty IBAction to unwind to
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameFromHomeSegue" {
            if let controller = segue.destination as? GameController {
                do {
                    // Apply the setting to the game controller
                    controller.gameSettings = try StorageManager().loadSettings()
                }
                catch {
                    // Provide default settings
                    controller.gameSettings = GameSettings()
                }
            }
        }
    }
}

