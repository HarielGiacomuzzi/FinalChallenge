//
//  PuffGamePad.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 9/3/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

class PuffGamePad: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @IBAction func pullButton(sender: AnyObject) {
        var dic = ["PuffGamePad":" ", "action":PlayerAction.PuffPull.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true);
    }
    @IBAction func pushButton(sender: AnyObject) {
        var dic = ["PuffGamePad":" ", "action":PlayerAction.PuffPush.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true);
    }
    
}