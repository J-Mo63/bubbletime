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
    let maxPongs: Int = 15
    let spawnRate: Double = 0.5
    let pongSize: CGFloat = 75
    
    var animatorController: AnimatorController?
    var gameTimer: Timer?
    var timerTick: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the physics controller
        animatorController = AnimatorController(context: self.view)
        animatorController!.start()
        
        // Start a timer loop
        gameTimer = Timer.scheduledTimer(withTimeInterval: spawnRate, repeats: true, block: { (gameTimer: Timer) in
            self.update()
        })
    }
    
    func update() {
        if (getPongCount() < maxPongs) {
            addPong()
        }
        
        if timerTick % 3 == 0 {
            for view in self.view.subviews {
                if view.tag >= 100 {
                    removePong(view as! Pong)
                    break
                }
            }
        }
        
        timerTick += 1
    }
    
    func addPong() {
        // Create the view at a random location in the allowable bounds
        let allowableX = UInt32(self.view.bounds.size.width) - UInt32(pongSize)
        let allowableY = UInt32(self.view.bounds.size.height) - UInt32(pongSize)
        let randPosX = CGFloat(arc4random_uniform(allowableX))
        let randPosY = CGFloat(arc4random_uniform(allowableY))
        
        let pong: Pong = Pong(frame: CGRect(x: randPosX, y: randPosY, width: pongSize, height: pongSize))
        
        pong.delegate = self
        pong.tag = uniqueTag()
        
        // Add the pong as a subview and set up the physics
        self.view.addSubview(pong)
        animatorController!.addObject(pong)
    }
    
    func removePong(_ pong: Pong) {
        animatorController!.removeObject(pong)
        
        if let pongInView = self.view.viewWithTag(pong.tag) {
            pongInView.removeFromSuperview()
        }
    }
    
    func animateRemoval(for pong: Pong) {
        let points: Points = Points(frame: CGRect(x: pong.frame.minX, y: pong.frame.minY, width: pongSize, height: pongSize))
        points.text = "10"
        self.view.addSubview(points)
    }
    
    func onPongTapped(_ tappedPong: Pong) {
        removePong(tappedPong)
        animateRemoval(for: tappedPong)
    }
    
    func uniqueTag() -> Int {
        while true {
            let randomTag = Int(arc4random_uniform(100) + 100)
            guard let _ = self.view.viewWithTag(randomTag) else {
                return randomTag
            }
        }
    }
    
    func getPongCount() -> Int {
        var count: Int = 0
        for view in self.view.subviews {
            if view.tag >= 100 {
                count += 1
            }
        }
        return count
    }
}
