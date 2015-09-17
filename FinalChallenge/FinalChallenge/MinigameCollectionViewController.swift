//
//  MinigameCollectionViewController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/31/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class MinigameCollectionViewController : UIViewController {
    
    var minigameCollection = [Minigame]()
    var scene : MinigameCollectionScene!
    override func viewDidLoad() {
        
        minigameCollection = GameManager.sharedInstance.allMinigames
        
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);
        
        scene = MinigameCollectionScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.viewController = self
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return minigameCollection.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomMinigameCollectionView
        
        cell.minigameImage.image = UIImage(named: minigameCollection[indexPath.row].rawValue)
        
        print(minigameCollection[indexPath.row].rawValue)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        switch(minigameCollection[indexPath.row]){
            case .FlappyFish: cell.specialTag = "flap"
            case .BombGame: cell.specialTag = "bomb"
            default: break
        }
        // Configure the cell
        return cell
    }
    
    //performSegueWithIdentifier("minigameSegue", sender: "flap")
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell : CustomMinigameCollectionView? = collectionView.cellForItemAtIndexPath(indexPath) as? CustomMinigameCollectionView{
            performSegueWithIdentifier("minigameSegue", sender: cell?.specialTag)
        }
        
    }
    
    func gameSelected(game:String!){
        performSegueWithIdentifier("minigameSegue", sender: game)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "minigameSegue" {
            let minivc = segue.destinationViewController as! MinigameDescriptionViewController
            switch sender as! String {
            case "flap":
                minivc.minigame = .FlappyFish
            case "bomb":
                minivc.minigame = .BombGame
            default:
                ()
            }
        }
        
    }
    
    
}