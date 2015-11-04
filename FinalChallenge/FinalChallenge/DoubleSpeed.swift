//
//  DoubleSpeed.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/4/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

class DoubleSpeed: ActiveCard {
    
    override init() {
        super.init()
        self.cardName = "Double Speed"
        imageName = "doubleSpeed"
        self.desc = "This cards makes you move  2 times the dice throw."
        self.trap = false
    }
    
    override func activate(targetPlayer: Player) {
        GameManager.sharedInstance.dicex2 = true
    }
}