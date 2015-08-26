//
//  IphoneConnectionViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class IphoneConnectionViewController: UIViewController, MCBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        ConnectionManager.sharedInstance.setupBrowser();
        ConnectionManager.sharedInstance.browser?.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil);

    }

    @IBAction func browseButtonPressed() {
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
    }
    
    // MARK: - MCBrowserViewControllerDelegate function

    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func connectionChanged(data : NSNotification){
        var a: AnyObject? = data.userInfo?.values.array[1];
        println("Connection Status : \(a)");
    }

}
