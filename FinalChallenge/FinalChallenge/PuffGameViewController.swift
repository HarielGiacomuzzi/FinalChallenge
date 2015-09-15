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
    class func unarchive(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks")
        
        let sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        var scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! PuffGameScene

        archiver.finishDecoding()
        return scene
    }
}

class PuffGameViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = PuffGameScene.unarchive("PuffGameScene") as? PuffGameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill;
            skView.presentScene(scene)
        }
    }
}