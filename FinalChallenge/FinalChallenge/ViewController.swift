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

    var iPadStream : NSOutputStream?
    @IBOutlet weak var testTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        ConnectionManager.sharedInstance.setupBrowser();
        ConnectionManager.sharedInstance.browser?.delegate = self;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "whoisResponse:", name: "ConnectionManager_WhoIsResponse", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveCard:", name: "ConnectionManager_SendCard", object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func whoisResponse(data : NSNotification?){
        let aux = ConnectionManager.sharedInstance.getStreamToIpad(ConnectionManager.sharedInstance.peerID!.displayName);
        if aux != nil{
            self.iPadStream = aux;
        }
    }

    @IBAction func sendStreamTest(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.iPadStream != nil{
                var buffer : [UInt8] = [1];
                self.iPadStream!.open()
                self.iPadStream!.write(&buffer, maxLength: buffer.count)
            }
        })
        
    }
    @IBAction func findGame(sender: AnyObject) {
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
    }
    
    // Notifies the delegate, when the user taps the done button
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
        let connectedPeers = ConnectionManager.sharedInstance.session.connectedPeers
        var connectedPlayers:[Player] = []
        for peer in connectedPeers {
            let player = Player()
            player.playerIdentifier = peer.displayName
            connectedPlayers.append(player)
        }
        GameManager.sharedInstance.players = connectedPlayers
        GameManager.sharedInstance.isMultiplayer = true
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }

    @IBAction func loadBoard(sender: AnyObject) {
        BoardGraph.SharedInstance.loadBoard("board_3");
    }
    
    
    @IBAction func gotoFlapGame() {
        performSegueWithIdentifier("minigameSegue", sender: "flap")
    }
    
    @IBAction func gotoBombGame() {
        performSegueWithIdentifier("minigameSegue", sender: "bomb")
    }
    @IBAction func getStreamToiPad(sender: AnyObject) {
        if ConnectionManager.sharedInstance.getIpadPeer() != nil{
            self.whoisResponse(nil);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "minigameSegue" {
            let minivc = segue.destinationViewController as! MiniGameViewController
            
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
//        GameManager.sharedInstance.updatePlayerMoney(GameManager.sharedInstance.players.first!, value: 15)
        
//        let cardData = ["player":GameManager.sharedInstance.players.first!.playerIdentifier, "item": "oi"]
//        let dic = ["addCard":" ", "dataDic" : cardData]
//        
//        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)

    }
    
    func receiveCard(data : NSNotification) {
        print("recebi algo")
    }
    
    @IBAction func openStore() {
        let cards = ["stealgold","stealgold","losecard","returnSquares","losecard"]
        let player = GameManager.sharedInstance.players.first!.playerIdentifier
        let dataDic = ["cards":cards, "player":player]
        let dic = ["openStore" : " ", "dataDic" : dataDic]
        print("?")
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }


}

