//
//  MinigameDescriptionViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/1/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class MinigameDescriptionViewController: UIViewController {

    @IBOutlet weak var minigameImage: UIImageView!
    @IBOutlet weak var minigameDescription: UITextView!
    
    var minigame = Minigame.FlappyFish
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        GameManager.sharedInstance.minigameDescriptionViewController = self
        if let path = NSBundle.mainBundle().pathForResource("MinigameDetails", ofType: "plist") {
            var dic = NSDictionary(contentsOfFile: path)
            switch minigame {
            case .FlappyFish:
                var game = dic?.objectForKey("FlappyFish") as! NSDictionary
                minigameDescription.text = game.objectForKey("description") as! String
            case .BombGame:
                var game = dic?.objectForKey("BombGame") as! NSDictionary
                minigameDescription.text = game.objectForKey("description") as! String
            default:
                ()
            }


        }
    
    }

    @IBAction func gotoMinigameButtonPressed() {
        performSegueWithIdentifier("gotoMinigameVC", sender: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMinigameVC" {
            let minivc = segue.destinationViewController as! MiniGameViewController
            minivc.minigame = minigame
        }
    }

}
