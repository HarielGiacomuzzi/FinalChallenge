//
//  FlappyGameViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/4/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class FlappyGameViewController: UIViewController {
    
    var scene = FlappyGameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
        
        scene = FlappyGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connectionChanged(){
        
    }
    
    /*func messageReceived(data:NSNotification){
        var data = data.userInfo?.values.array[0]
        println(data as! String)   //Optional(<4a756d70 202b2042 72756e6f 204b6965 6c696e67>)
        scene.playerJump()
    }*/
    func messageReceived(data : NSNotification){
        var a = ((data.userInfo as! NSDictionary).valueForKey("data") as! NSData);
        var message = String(NSString(data: a, encoding: NSUTF8StringEncoding)!);
        println(message)
        
        var value = ConnectionManager.sharedInstance.session.connectedPeers
        println(value)
    }
}
