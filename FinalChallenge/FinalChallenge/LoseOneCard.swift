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
        imageName = "losecard"
        self.desc = "This card takes another  card from a player."
        self.trap = true
    }
    
    override func activate(targetPlayer:Player) {
        self.loseCard(targetPlayer)
    }
    
    func loseCard(player: Player){
        CardManager.ShareInstance.loseCard(player)
    }
}
