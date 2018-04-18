//
//  Pong.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class Pong: UIButton {
    @IBOutlet weak var button: UIButton!
    
    override var layer: CALayer {
        let layer = super.layer
        layer.cornerRadius = 30
        return layer
    }
    
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "Pong", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
    }
}
