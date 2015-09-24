//
//  LoseOneCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/23/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class LoseCard : ActiveCard{
    
    override init() {
        super.init()
        self.cardName = "LoseCard"
    }
    
    override func activate(targetPlayer:Player) {
        self.loseCard(targetPlayer)
    }
    
    func loseCard(player: Player){
        GameManager.sharedInstance.loseCard(player)
    }
}
