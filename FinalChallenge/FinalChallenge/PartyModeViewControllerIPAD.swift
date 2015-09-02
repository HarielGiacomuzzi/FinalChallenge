//
//  PartyModeViewControllerIPAD.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/2/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PartyModeViewControllerIPAD : UIViewController, MCBrowserViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var turnSelector: UIPickerView!
    var turnSelectorComponents = [String()]
    var turns = Int()
    
    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player1Label: UILabel!
    
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var player2Label: UILabel!
    
    @IBOutlet weak var player3Image: UIImageView!
    @IBOutlet weak var player3Label: UILabel!
    
    @IBOutlet weak var player4Image: UIImageView!
    @IBOutlet weak var player4Label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true)
        ConnectionManager.sharedInstance.setupBrowser()
        ConnectionManager.sharedInstance.browser?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_ControlAction", object: nil);
        
        turnSelector.dataSource = self
        turnSelector.delegate = self
        
        turnSelectorComponents = ["5","10","20"]
        
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
        
        switch(GameManager.sharedInstance.players.count){
        case 4: //player4Image.alpha = 1
                player4Label.text = GameManager.sharedInstance.players[3].playerIdentifier
                fallthrough
        case 3: //player3Image.alpha = 1
                player3Label.text = GameManager.sharedInstance.players[2].playerIdentifier
                fallthrough
        case 2: //player2Image.alpha = 1
                player2Label.text = GameManager.sharedInstance.players[1].playerIdentifier
                fallthrough
        case 1: //player1Image.alpha = 1
                player1Label.text = GameManager.sharedInstance.players[0].playerIdentifier
                break
        default: break
        }
        
        
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }
    @IBAction func ConnectPlayers(sender: AnyObject) {
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
    }
    
    func gameSettings(){
        
    }
    
    //MARK: Picker data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return turnSelectorComponents.count
    }
    
    //MARK: Picker Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return turnSelectorComponents[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        turns = turnSelectorComponents[row].toInt()!
    }
    
    func messageReceived(data : NSNotification){
        var identifier = data.userInfo!["peerID"] as! String
        var dictionary = data.userInfo!["actionReceived"] as! NSDictionary
        var message = dictionary["avatar"] as! String
        
        switch(identifier){
        case player1Label.text! : player1Image.alpha = 1
        case player2Label.text! : player2Image.alpha = 1
        case player3Label.text! : player3Image.alpha = 1
        case player4Label.text! : player4Image.alpha = 1
        default: break
        }
        
        println("Mensagem: \(message) e Identifier: \(identifier)")
        /*for player in players {
            if player.identifier == identifier {
                var message = dictionary["way"] as! String
                var messageEnum = PlayerAction(rawValue: message)
                if messageEnum == .Up {
                    player.goUp()
                } else {
                    player.goDown()
                }
            }
        }*/
    }

}