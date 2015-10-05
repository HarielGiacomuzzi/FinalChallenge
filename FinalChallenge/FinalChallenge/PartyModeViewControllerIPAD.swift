//
//  PartyModeViewControllerIPAD.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/2/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SpriteKit

class PartyModeViewControllerIPAD : UIViewController, MCBrowserViewControllerDelegate{
    
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
    
    
    var arrayAvatars = [String()]
    
    var scene : SetupPartyScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        GameManager.sharedInstance.ipadAvatarViewController = self
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true)
        ConnectionManager.sharedInstance.setupBrowser()
        ConnectionManager.sharedInstance.browser?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_GameSetup", object: nil);
        /*
        turnSelector.dataSource = self
        turnSelector.delegate = self
        
        turnSelectorComponents = ["5","10","20"]
        */
        
        scene = SetupPartyScene(size: CGSize(width: 1024, height: 768))
        scene!.viewController = self
        
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
        print("apresentei a cena sem crashar")

        
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
        
        switch(GameManager.sharedInstance.players.count){
        case 4: 
                //player4Label.text = GameManager.sharedInstance.players[3].playerIdentifier
                fallthrough
        case 3:
                //player3Label.text = GameManager.sharedInstance.players[2].playerIdentifier
                fallthrough
        case 2:
                //player2Label.text = GameManager.sharedInstance.players[1].playerIdentifier
                fallthrough
        case 1:
               // player1Label.text = GameManager.sharedInstance.players[0].playerIdentifier
                break
        default: break
        }
        
        
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
        ConnectionManager.sharedInstance.browser?.dismissViewControllerAnimated(true, completion: { () -> Void in})
    }
    @IBAction func ConnectPlayers() {
        self.presentViewController(ConnectionManager.sharedInstance.browser!, animated: true) { () -> Void in}
    }
    
    @IBAction func gotoBoardGame(){
        let change = "change"
        let c = ["change":change]
        let dic = ["IphoneChangeView": " ", "change":c]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
        BoardGraph.SharedInstance.loadBoard("board_3");
        
        self.performSegueWithIdentifier("gotoBoardGame", sender: nil)
        
    }
    func gameSettings(){
        GameManager.sharedInstance.totalGameTurns = turns
    }
    
  /*  //MARK: Picker data source
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
    */
    func messageReceived(data : NSNotification){
        let identifier = data.userInfo!["peerID"] as! String
        let dictionary = data.userInfo!["avatar"] as! NSDictionary
        let message = dictionary["avatar"] as! String
        
        
        for p in GameManager.sharedInstance.players {
            if identifier == p.playerIdentifier{
                if let notNil = p.avatar{
                    // verifica se tem avatar caso tenha faz
                    arrayAvatars.removeObject(notNil)
                }
            }
        }
        
        
        switch(identifier){
        case GameManager.sharedInstance.players[0].playerIdentifier : // player1Image.image = UIImage(named: message)
                                  scene?.char1.texture = SKTexture(imageNamed: message)
                                  scene?.riseCharacter(scene!.char1)
        
        case GameManager.sharedInstance.players[1].playerIdentifier : // player2Image.image = UIImage(named: message)
                                    scene?.char2.texture = SKTexture(imageNamed: message)
                                    scene?.riseCharacter(scene!.char2)
        case GameManager.sharedInstance.players[2].playerIdentifier : // player3Image.image = UIImage(named: message)
                                    scene?.char3.texture = SKTexture(imageNamed: message)
                                    scene?.riseCharacter(scene!.char3)

        case GameManager.sharedInstance.players[3].playerIdentifier : //player4Image.image = UIImage(named: message)
                                    scene?.char4.texture = SKTexture(imageNamed: message)
                                    scene?.riseCharacter(scene!.char4)

        default: break
        }
        //defines the player avatar image or right now the color
        for p in GameManager.sharedInstance.players {
            if identifier == p.playerIdentifier{
                p.avatar = message
                switch(message){
                    case "paladinCard": p.color = UIColor.redColor()
                    case "rangerCard": p.color = UIColor.whiteColor()
                    case "thiefCard": p.color = UIColor.blackColor()
                    case "wizardCard": p.color = UIColor.blueColor()
                    default: break
                }
            }
        }
        print("Mensagem: \(message) e Identifier: \(identifier)")
        updateIphoneUsersData(message)
    }

    
    func updateIphoneUsersData(avat:String){
        
        arrayAvatars.append(avat)
        
        print(arrayAvatars)
        
        let arrayPlayers = arrayAvatars
        let array = ["arrayPlayers":arrayPlayers]
        let dic = ["IphoneGameSetup":" ", "arrayPlayers":array]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    
    
    
}