//
//  FlappyGameViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/4/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

class FlappyGameViewController: UIViewController {
    
    @IBOutlet weak var GameOverView: UIView!
    
    var scene = FlappyGameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
        scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
    //    skView.showsPhysics = true
        scene.gameController = self
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connectionChanged(){
        
    }
    

    func messageReceived(data : NSNotification){
        var peerID = ((data.userInfo as! NSDictionary).valueForKey("peerID") as! MCPeerID);
        var data = ((data.userInfo as! NSDictionary).valueForKey("data") as! NSData);
        var peerDisplayName = peerID.displayName
        var message = String(NSString(data: data, encoding: NSUTF8StringEncoding)!);
        let messageEnum = PlayerAction(rawValue: message)
        scene.playerSwim(peerDisplayName, way: messageEnum!)
    }
    

}
