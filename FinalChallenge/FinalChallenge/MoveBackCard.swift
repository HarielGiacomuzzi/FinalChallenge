//
//  MoveBackCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/23/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class MoveBackCard : ActiveCard{
    
    var moveValue = -5
    
    override init() {
        super.init()
        self.cardName = "MoveBackCard"
        imageName = "returnSquares"
    }
    
    override func activate(targetPlayer:Player) {
        self.backCard(targetPlayer)
    }
    
    func backCard(player: Player){
        GameManager.sharedInstance.updatePlayerPosition(moveValue, player: player)
    }
}
