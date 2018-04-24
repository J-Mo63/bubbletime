//
//  Pong.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class Points: UILabel {
    var lifespanTimer: Timer?
    var timerTick: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = UIColor.white
        self.font = UIFont(name: "BadWrite_Full", size: 50)
        
        lifespanTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (lifespanTimer: Timer) in
            self.update()
        })
    }
    
    func update() {
        alpha = alpha - 0.02
        self.center.y -= 1
        
        if timerTick > 50 {
            self.removeFromSuperview()
        }
        
        timerTick += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
