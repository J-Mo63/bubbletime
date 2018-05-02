//
//  Pong.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class Points: UILabel {
    
    // Constants
    let lifespan: Int = 50
    
    // Fields
    var lifespanTimer: Timer?
    var timerTick: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up default properties
        self.textColor = UIColor.white
        self.font = UIFont(name: "BadWrite_Full", size: 50)
        
        // Start a timer loop to run the update function
        lifespanTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (lifespanTimer: Timer) in
            self.update()
        })
    }
    
    func update() {
        // Make the points label float up and slowly disappear
        self.center.y -= 1
        alpha = alpha - 0.02
        
        // Destry the object after it has reached its lifespan
        if timerTick > lifespan {
            self.removeFromSuperview()
        }
        
        // Increment the tick
        timerTick += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
