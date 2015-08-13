//
//  ViewController.swift
//  PingPongHero
//
//  Created by Hariel Giacomuzzi on 7/20/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InitialController: UIViewController, MCBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startConnection(sender: AnyObject) {
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        ConnectionManager.sharedInstance.setupBrowser();
        ConnectionManager.sharedInstance.browser?.delegate = self;
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
        
    }
    
    // Notifies the delegate, when the user taps the done button
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }

}
