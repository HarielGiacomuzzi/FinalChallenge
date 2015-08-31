//
//  GamePadController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class GamePadController : UIViewController{
    
    @IBAction func upDataSender() {
        
        var action = ["way":PlayerAction.Up.rawValue]
        var dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }

    @IBAction func downDataSender() {
        var action = ["way":PlayerAction.Down.rawValue]
        var dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
}
