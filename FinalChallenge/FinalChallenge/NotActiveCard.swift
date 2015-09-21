//
//  NotActiveCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class NotActiveCard : Card {
    
    override init() {
        super.init()
        self.usable = false
        self.storeValue = 100
    }
    
}