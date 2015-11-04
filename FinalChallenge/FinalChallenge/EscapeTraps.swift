//
//  EscapeTraps.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/4/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

class EscapeTraps: ActiveCard {
    override init() {
        super.init()
        self.cardName = "Escape Traps"
        imageName = "escapeTraps"
        self.desc = "This cards make you  invulnerable to traps."
        self.trap = false
    }
    
    override func activate(targetPlayer: Player) {
        GameManager.sharedInstance.escapeFlag = true
    }
}
