//
//  StealMoneyCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class ActiveCard :Card {
    
    var used = Bool()
    
    override init() {
        super.init()
        self.usable = true
        self.storeValue = 100
    }
    
    func activate(targetPlayer:Player){
        
    }
}