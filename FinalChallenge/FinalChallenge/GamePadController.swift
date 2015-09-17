//
//  GamePadController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class GamePadController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
    }
    
    @IBAction func upDataSender() {
        
        let action = ["way":PlayerAction.Up.rawValue]
        let dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }

    @IBAction func downDataSender() {
        let action = ["way":PlayerAction.Down.rawValue]
        let dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    func closeController(data:NSNotification) {
        navigationController?.popViewControllerAnimated(false)
    }
    
}
