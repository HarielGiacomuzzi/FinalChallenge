//
//  GamePadController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class GamePadController : UIViewController{
    
    @IBAction func JumpDataSender(sender: AnyObject) {
        ConnectionManager.sharedInstance.sendStringToPeer("Jump")
    }
}
