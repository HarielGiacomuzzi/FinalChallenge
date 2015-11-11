//
//  ExtraDice.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/4/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

class ExtraDice: ActiveCard {
    override init(){
        super.init()
        self.cardName = "Extra Dice"
        imageName = "extraDice"
        self.desc = "This card let you  throw two dices."
        self.trap = false
    }
    
    override func activate(targetPlayer: Player) {
        GameManager.sharedInstance.doubleDice = true
        let dataDic = ["player":targetPlayer.playerIdentifier, "double": true]
        let dicc = ["DoubleMove":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
    }
}
