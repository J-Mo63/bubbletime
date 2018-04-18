//
//  GameController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    @IBOutlet weak var pong: UIButton!
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the animator
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Add gravity
        let gravity = UIGravityBehavior(items: [pong])
        var gravityDirection = CGVector()
        gravityDirection.dx = 0.0
        gravityDirection.dy = 1.0
        gravity.gravityDirection = gravityDirection
        animator?.addBehavior(gravity)
        
        // Add bounce
        let bounce = UIDynamicItemBehavior(items: [pong])
        bounce.elasticity = 0.5
        animator?.addBehavior(bounce)
        
        // Add collision
        let boundaries = UICollisionBehavior(items: [pong])
        boundaries.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(boundaries)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func touchedPong(_ sender: UIButton) {
        // Add velocity
        let velocity = UIDynamicItemBehavior(items: [pong])
        let force = CGFloat(100.5)
        velocity.addAngularVelocity(force, for: pong)
        animator?.addBehavior(velocity)
    }
    
}
