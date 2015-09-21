//
//  StealMoneyCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class ActiveCard :Card {

    var stealValue = 100
    
    override init() {
        super.init()
        self.usable = true
        self.storeValue = 100
    }
    func stealCard(player: Player){
        let stolenValue = GameManager.sharedInstance.updatePlayerMoney(player, value: -stealValue)
        _ = GameManager.sharedInstance.updatePlayerMoney(self.cardOwner, value: stolenValue)
    }
}