//
//  GameController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class GameController: UIViewController, PongDelegate {
    
    // Game options
    let maxPongs: Int = 15
    let spawnRate: Double = 0.5
    let pongSize: CGFloat = 75
    var gameTime: Int = 5
    var gamePoints: Int = 0
    
    // Dimensions
    var allowableX: UInt32?
    var allowableY: UInt32?
    
    // Fields
    var animatorController: AnimatorManager?
    var gameTimer: Timer?
    var timerTick: Int = 0
    var lastTapped: PongType?
    
    // Outlets
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the animator controller
        animatorController = AnimatorManager(context: self.view)
        animatorController!.start()
        
        // Set the dimensions
        allowableX = UInt32(self.view.bounds.size.width) - UInt32(pongSize)
        allowableY = UInt32(self.view.bounds.size.height) - UInt32(pongSize)
        
        // Set the labels to initial values
        timerLabel.text = "\(gameTime)s"
        pointsLabel.text = "\(gamePoints) points"
        
        // Start a timer loop to run the update function
        gameTimer = Timer.scheduledTimer(withTimeInterval: spawnRate, repeats: true, block: { (gameTimer: Timer) in
            self.update()
        })
    }
    
    func update() {
        // Add more pongs if the max hasn't been reached
        if (getPongCount() < maxPongs) {
            addPong()
        }
        
        // End the game if the timelimit is reached
        if gameTime <= 0 {
            gameTimer?.invalidate()
            self.performSegue(withIdentifier: "endGameSegue", sender: self)
        }
        
        // Remove a "random" pong every second tick (and also decrement the timer)
        if timerTick % 3 == 2 {
            gameTime -= 1
            timerLabel.text = "\(gameTime)s"
            for view in self.view.subviews {
                if view.tag >= 100 {
                    destroyPong(view as! Pong)
                    break
                }
            }
        }
        
        // Increment the tick
        timerTick += 1
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
        // Destroy the pong and show its points value
        destroyPong(tappedPong)
        showPoints(for: tappedPong)
        gamePoints += calculatePoints(for: tappedPong.type)
        lastTapped = tappedPong.type
        pointsLabel.text = "\(gamePoints) points"
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
            endGameController.playerScore = PlayerScore(name: "Swifty McVay", score: gamePoints)
        }
    }
}
