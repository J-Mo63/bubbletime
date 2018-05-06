//
//  GameController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class GameController: UIViewController, PongDelegate {
    
    // Constants
    let pongSize: CGFloat = 75
    let timerSpeed: Double = 1.0
    let removalRate: Int = 3
    
    // Game Settings
    var maxPongs: Int = 15
    var gameTime: Int = 60
    var totalGameTime: Int = 60
    var highScore: Int = 0
    
    // Dimensions
    var allowableX: UInt32?
    var allowableY: UInt32?
    
    // Fields
    var gameSettings: GameSettings?
    var animatorController: AnimatorManager?
    var audioHelper: AudioHelper?
    var gameTimer: Timer?
    var lastTapped: PongType?
    var gamePoints: Int = 0
    
    // Outlets
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameTimeProgress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply the game settings
        if let settings = gameSettings {
            maxPongs = settings.maxPongs
            gameTime = settings.gameTimeValue()
            totalGameTime = settings.gameTimeValue()
        }
        
        // Set the high score
        loadHighScore()
        
        // Create the animator controller
        animatorController = AnimatorManager(context: self.view)
        animatorController!.startGravityUpdates()
        
        // Set the dimensions
        allowableX = UInt32(self.view.bounds.size.width) - UInt32(pongSize)
        allowableY = UInt32(self.view.bounds.size.height) - UInt32(pongSize)
        
        // Set the labels to initial values
        displayHighScore()
        pointsLabel.text = "\(gamePoints) points"
        
        // Start a timer loop to run the update function
        gameTimer = Timer.scheduledTimer(withTimeInterval: timerSpeed, repeats: true, block: { (gameTimer: Timer) in
            self.update()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            // Create the audio helper
            audioHelper = try AudioHelper(audioTitle: "pop", fileExtension: "mp3")
        }
        catch {
            handleError()
        }
    }
    
    func update() {
        // End the game if the timelimit is reached
        if gameTime <= 0 {
            gameTimer?.invalidate()
            self.performSegue(withIdentifier: "endGameSegue", sender: self)
        }
        
        // Decrement the timer
        gameTime -= 1
        let currentProgress = Float(gameTime)/Float(totalGameTime)
        UIView.animate(withDuration: timerSpeed + 0.5) {
            self.gameTimeProgress.setProgress(currentProgress, animated: true)
        }
        
        
        // Add more pongs if the max hasn't been reached
        if (getPongCount() < maxPongs) {
            let randomToAdd = arc4random_uniform(UInt32(maxPongs - getPongCount()))
            for _ in 0...randomToAdd {
                addPong()
            }
        }
        
        // Remove a "random" pong every so often
        if gameTime % removalRate == 0 {
            var randomToDestroy = arc4random_uniform(UInt32(getPongCount()))
            for view in self.view.subviews {
                if view.tag >= 100 {
                    if randomToDestroy > 0 {
                        destroyPong(view as! Pong)
                        randomToDestroy -= 1
                    }
                    else {
                        break
                    }
                }
            }
        }
    }
    
    func addPong() {
        // Create the view at a random location in the allowable bounds
        let randPosX = CGFloat(arc4random_uniform(allowableX!))
        let randPosY = CGFloat(arc4random_uniform(allowableY!))
        
        // Create the view at that location
        let pong: Pong = Pong(frame: CGRect(x: randPosX, y: randPosY, width: pongSize, height: pongSize))
        
        // Set the delegate and assign it a unique tag
        pong.delegate = self
        pong.tag = uniqueTag()
        
        // Add the pong as a subview and register it up with the animator
        self.view.addSubview(pong)
        animatorController!.addObject(pong)
    }
    
    func destroyPong(_ pong: Pong) {
        // Deregister the pong with the animator
        animatorController!.removeObject(pong)
        
        // Remove the pong from the view
        if let pongInView = self.view.viewWithTag(pong.tag) {
            pongInView.removeFromSuperview()
        }
    }
    
    func showPoints(for pong: Pong) {
        // Create the view at the location of the destroyed pong
        let points: Points = Points(frame: CGRect(x: pong.frame.minX, y: pong.frame.minY, width: pongSize, height: pongSize))
        
        // Set the point value and add it to the view
        points.text = String(calculatePoints(for: pong.type))
        self.view.addSubview(points)
    }
    
    func onPongTapped(_ tappedPong: Pong) {
        // Destroy the pong
        destroyPong(tappedPong)
        
        // Play the sound effect
        audioHelper?.player.play()
        
        // Show its points value
        showPoints(for: tappedPong)
        gamePoints += calculatePoints(for: tappedPong.type)
        lastTapped = tappedPong.type
        pointsLabel.text = "\(gamePoints) points"
        
        // Check if it's the high score
        displayHighScore()
    }
    
    func displayHighScore() {
        if gamePoints > highScore {
            // Set the high score to the current points
            highScore = gamePoints
        }
        // Update the label
        highScoreLabel.text = "High Score \(highScore)"
    }
    
    func calculatePoints(for pongType: PongType) -> Int {
        var points: Int = pongType.points()
        if (pongType == lastTapped) {
            points = Int((Double(points) * 1.5).rounded(.up))
        }
        return points
    }
    
    func uniqueTag() -> Int {
        while true {
            // Create a random tag in the pong range (>100)
            let randomTag = Int(arc4random_uniform(100) + 100)
            // Return it if it doesn't already exist in the view
            guard let _ = self.view.viewWithTag(randomTag) else {
                return randomTag
            }
        }
    }
    
    func getPongCount() -> Int {
        // Count the views with tags in the pong range (>100)
        var count: Int = 0
        for view in self.view.subviews {
            if view.tag >= 100 {
                count += 1
            }
        }
        return count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "endGameSegue") {
            let endGameController = segue.destination as! EndGameController
            
            // Give the next controller the game results
            endGameController.finalScore = gamePoints
        }
    }
    
    func loadHighScore() {
        do {
            // Load the high score
            var scores = try StorageManager().loadScores()
            scores.sort(by: { $0.score > $1.score })
            highScore = scores[0].score
        }
        catch {
            // Set to a default value
            highScore = 0
        }
    }
    
    func handleError() {
        showGeneralErrorMessage(in: self)
    }
}
