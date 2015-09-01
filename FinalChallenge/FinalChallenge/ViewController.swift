//
//  ViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 7/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        ConnectionManager.sharedInstance.setupBrowser();
        ConnectionManager.sharedInstance.browser?.delegate = self;
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findGame(sender: AnyObject) {
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
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
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }

    @IBAction func loadBoard(sender: AnyObject) {
        BoardGraph.SharedInstance.loadBoard("board_2");
    }
    
    
    @IBAction func gotoFlapGame() {
        performSegueWithIdentifier("minigameSegue", sender: "flap")
    }
    
    @IBAction func gotoBombGame() {
        performSegueWithIdentifier("minigameSegue", sender: "bomb")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "minigameSegue" {
            let minivc = segue.destinationViewController as! MinigameDescriptionViewController
            switch sender as! String {
            case "flap":
                minivc.minigame = .FlappyFish
            case "bomb":
                minivc.minigame = .BombGame
            default:
                ()
            }
        }
        
    }
    @IBAction func botaoDeTeste(sender: AnyObject) {
        var dic = ["closeController":""]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)

    }
    
}

