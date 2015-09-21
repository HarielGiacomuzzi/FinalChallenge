//
//  StealGoldCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class StealGoldCard : ActiveCard{
    
    var stealValue = 100
    
    override init() {
        super.init()
        self.cardName = "StealGoldCard"
    }
    
    override func activate(targetPlayer:Player) {
        self.stealCard(targetPlayer)
    }
    
    func stealCard(player: Player){
        let stolenValue = GameManager.sharedInstance.updatePlayerMoney(player, value: -stealValue)
        _ = GameManager.sharedInstance.updatePlayerMoney(self.cardOwner, value: stolenValue)
    }
}