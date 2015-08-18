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
    
    var scene = FlappyGameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
//        scene = FlappyGameScene(size: view.bounds.size)
        scene = FlappyGameScene(size: CGSize(width: 1024, height: 768))
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
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
        var b = peerID.displayName
//        scene.move
        println(b)

        
        var message = String(NSString(data: data, encoding: NSUTF8StringEncoding)!);
        println(message)
        
        scene.playerSwim(b, way: message)
//        scene.playerJump(message)

//        var value = ConnectionManager.sharedInstance.session.connectedPeers
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
}
