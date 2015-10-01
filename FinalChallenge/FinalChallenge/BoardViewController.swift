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
        
        let sceneData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
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
    
    var scene : MainBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.sharedInstance.boardGameViewController = self
        self.setupScene()
    }
    
    func setupScene(){
        //let scene = MainBoard(size: self.view.frame.size)
        scene = MainBoard.unarchiveFromFile("MainBoard") as! MainBoard
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
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMinigame" {
            scene.removeAllActions()
            scene.removeAllChildren()
            scene = nil
            let minivc = segue.destinationViewController as! MiniGameViewController
            minivc.minigame = Minigame(rawValue: sender as! String)!
        }
    }
    
    deinit{
        print("Deu deinit na board view")
    }
}