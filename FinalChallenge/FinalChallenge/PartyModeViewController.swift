//
//  PartyModeViewController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/31/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//
import UIKit
import SpriteKit


class PartyModeViewController : UIViewController{
    
    var scene : PartyModeScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true)
        ConnectionManager.sharedInstance.setupBrowser()
        //ConnectionManager.sharedInstance.browser?.delegate = self
        
        scene = PartyModeScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
    }
    
    func changeView(){
        self.performSegueWithIdentifier("gotoPlayerPad", sender: nil)
    }
    
}