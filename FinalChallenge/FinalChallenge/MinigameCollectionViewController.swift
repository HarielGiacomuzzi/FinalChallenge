//
//  MinigameCollectionViewController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/31/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
class MinigameCollectionViewController : UIViewController {
    
    var minigameCollection = [String]()
    
    override func viewDidLoad() {
        minigameCollection = ["Flappy Fish", "Bomb Game", "Third Game", "Last Game"]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomMinigameCollectionView
        switch minigameCollection[indexPath.row]{
            case "Flappy Fish": cell.backgroundColor = UIColor.redColor(); break
            case "Bomb Game": cell.backgroundColor = UIColor.blueColor(); break
            case "Third Game": cell.backgroundColor = UIColor.whiteColor(); break
            case "Last Game": cell.backgroundColor = UIColor.purpleColor(); break
            default : cell.backgroundColor = UIColor.greenColor(); break
        }
        // Configure the cell
        return cell
    }
}