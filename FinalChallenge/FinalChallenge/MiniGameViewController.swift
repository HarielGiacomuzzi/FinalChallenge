//
//  MiniGamesViewController.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 21/08/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity
import Foundation

class MiniGameViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var GameOverView: UIView!
    
    var scene = MinigameScene()
    
    var minigame = Minigame.FlappyFish
   // var minigame = Minigame.BombGame
    
    var playerRank:[String] = []
    
    var stb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var popup: MinigameGameOverController!
    var popupSinglePlayer: MinigameGameOverControllerSinglePlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Dei load na minigameview controller")
        GameManager.sharedInstance.minigameViewController = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_ControlAction", object: nil);
        
        //initializate popup veiwcontroler for multiplayer
        popup = stb.instantiateViewControllerWithIdentifier("MinigameGameOverController") as! MinigameGameOverController
        popup.modalPresentationStyle = .Popover
        popup.preferredContentSize = CGSizeMake(50,50)
        
        //initializate popup veiwcontroler for singleplayer
        popupSinglePlayer = stb.instantiateViewControllerWithIdentifier("MinigameGameOverControllerSinglePlayer") as! MinigameGameOverControllerSinglePlayer
        popupSinglePlayer.modalPresentationStyle = .Popover
        popupSinglePlayer.preferredContentSize = CGSizeMake(50,50)
        
        switch minigame {
        case .FlappyFish:
            scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
        case .BombGame:
            scene = BombTGameScene(size: CGSize(width: 1024, height: 768))
        default:
            print("porraaaa")
        }
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        scene.gameController = self
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        print("apresentei a cena sem crashar")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }
    
    func messageReceived(data : NSNotification){
        let peerDisplayName = data.userInfo!["peerID"] as! String
        let data = data.userInfo!["actionReceived"] as! NSDictionary
        scene.messageReceived(peerDisplayName, dictionary: data)
    }
    
    func gameOverController(playerArray:[String]){
        self.playerRank = playerArray
        popup.player = Array(playerRank.reverse())
        let popoverMenuViewController = popup.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1)
        presentViewController(popup, animated: true,completion: nil)
        
    }
    
    func gameOverControllerSinglePlayer(time:Int){
        popupSinglePlayer.timerText = time
        let popoverMenuViewController = popupSinglePlayer.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.view
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1)
        presentViewController(popupSinglePlayer, animated: true,completion: nil)
    }
    
    func dismmissMinigameView(){
         self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    /*func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }*/

}
