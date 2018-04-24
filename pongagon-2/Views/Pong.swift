//
//  Pong.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 18/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit

class Pong: UIButton {
    weak var delegate: PongDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.setBackgroundImage(#imageLiteral(resourceName: "pong.png"), for: UIControlState())
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = bounds.maxX/20
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("Green", for: UIControlState())
        self.titleLabel!.font = UIFont(name: "BadWrite_Full", size: 35)
        self.setTitleColor(UIColor.black , for: UIControlState())
        self.layer.cornerRadius = (bounds.maxX/2)
        self.layer.masksToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onPongTapped(self)
    }
}

protocol PongDelegate: AnyObject {
    func onPongTapped(_ tappedPong: Pong)
}
