//
//  iPhonePlayerViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

class iPhonePlayerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_PlayerTurn", object: nil);
    }
    
    func messageReceived(data : NSNotification){
        self.performSegueWithIdentifier("gotoDiceView", sender: nil)
        
    }
}