//
//  InitialViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class InitialViewController: UIViewController , MCBrowserViewControllerDelegate
    {

    //let idiom = UI_USER_INTERFACE_IDIOM()
    //let iPad = UIUserInterfaceIdiom.Pad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true)
        ConnectionManager.sharedInstance.setupBrowser()
        ConnectionManager.sharedInstance.browser?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func partyModeButton() {

        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
        
        //if idiom == iPad {
          //  performSegueWithIdentifier("ipadSegue", sender: nil)
        //} else {
          //  performSegueWithIdentifier("iphoneSegue", sender: nil)
        //}
        
    }

    // Notifies the delegate, when the user taps the done button
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        var connectedPlayers:[Player] = []
        for peer in connectedPeers {
            let player = Player()
            player.playerIdentifier = peer.displayName
            connectedPlayers.append(player)
        }
        GameManager.sharedInstance.players = connectedPlayers
        self.performSegueWithIdentifier("gotoPartyMode", sender: nil)
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
