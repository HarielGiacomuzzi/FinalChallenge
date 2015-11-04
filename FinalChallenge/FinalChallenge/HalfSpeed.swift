//
//  HalfSpeed.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 11/4/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

class HalfSpeed: ActiveCard {
    
    override init() {
        super.init()
        self.cardName = "Half Speed"
        imageName = "halfSpeed"
        self.desc = "This card cuts other  player's movement in half."
        self.trap = true
    }
    override func activate(targetPlayer: Player) {
        let dataDic = ["player":targetPlayer.playerIdentifier, "half": true]
        let dicc = ["HalfMove":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
    }
}