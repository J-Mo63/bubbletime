//
//  Pong.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class Pong: UIButton {
    
    // Fields
    weak var delegate: PongDelegate?
    let type: PongType
    
    override init(frame: CGRect) {
        // Get a randomly assigned type
        self.type = PongType.assign()
        super.init(frame: frame)
        
        // Set up the type-specific properties
        self.setTitle(type.name(), for: UIControlState())
        
        // Set up default properties
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = bounds.maxX/20
        self.layer.borderColor = UIColor.black.cgColor
        self.titleLabel!.font = UIFont(name: "BadWrite_Full", size: 35)
        self.setTitleColor(UIColor.black , for: UIControlState())
        self.layer.cornerRadius = (bounds.maxX/2)
        self.layer.masksToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Send touch event to deleagte callback
        delegate?.onPongTapped(self)
    }
}

// The pong's delegate protocol
protocol PongDelegate: AnyObject {
    func onPongTapped(_ tappedPong: Pong)
}

// An enum of pong types
enum PongType: Int {
    case red, pink, green, blue, black
    
    func name() -> String {
        let colourNames: [String] = ["red", "pink", "green", "blue", "black"]
        // Return the colour name
        return colourNames[self.hashValue]
    }
    
    func points() -> Int {
        let pointVals: [Int] = [1, 2, 5, 8, 10]
        // Return the point value
        return pointVals[self.hashValue]
    }
    
    static func assign() -> PongType {
        let probabilityVals: [Int] = [40, 30, 15, 10, 5]
        let randomNumber = Int(arc4random_uniform(100))
        
        var currentProbability: Int = 0
        for probability in probabilityVals {
            currentProbability += probability
            if randomNumber <= currentProbability {
                return PongType.init(rawValue: probabilityVals.index(of: probability)!)!
            }
        }
        // The method has to return something but this
        // should never be called anyway
        return .black
    }
}
