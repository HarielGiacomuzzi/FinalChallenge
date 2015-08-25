//
//  BoardViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/5/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks")
        
        let sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        var scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKNode
        if(false){
            scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! BoardScene
        }else{
            scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MainBoard
        }
        archiver.finishDecoding()
        return scene
    }
}

class BoardViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = MainBoard(size: self.view.frame.size)
        if let scene = MainBoard.unarchiveFromFile("MainBoard") as? MainBoard {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = self;
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}