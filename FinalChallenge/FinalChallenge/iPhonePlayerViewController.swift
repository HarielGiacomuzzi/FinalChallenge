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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
    }
    
    func messageReceived(data : NSNotification){
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data.userInfo!["data"] as! NSData) as? NSDictionary{
            if message.valueForKey("playerTurn") != nil && message.valueForKey("playerID") as! String  ==  ConnectionManager.sharedInstance.peerID.displayName {
                self.performSegueWithIdentifier("gotoDiceView", sender: nil)
                //self.presentViewController(viewMarota, animated: true, completion: nil)
            }
        }
    }
}