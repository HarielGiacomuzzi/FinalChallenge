//
//  NotActiveCard.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class NotActiveCard : Card {
    
    var endGameValue = Int()
    
    init(name : String , value : Int, im:String) {
        super.init()
        self.cardName = name
        self.imageName = im
        self.usable = false
        self.storeValue = 100 + value
        self.endGameValue = value
    }
}