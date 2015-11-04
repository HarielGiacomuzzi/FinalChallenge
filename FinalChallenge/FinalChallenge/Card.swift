//
//  Cards.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class Card : NSObject{
    var cardName = String()
    //var name = String()
    var usable = Bool()
    var storeValue = Int()
    var cardOwner = Player()
    var imageName = String()
    var desc = String()
}