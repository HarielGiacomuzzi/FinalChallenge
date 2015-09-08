//
//  MinigameGameOverControllerSinglePlayer.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/8/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class MinigameGameOverControllerSinglePlayer : UIViewController{
    
    @IBOutlet weak var timer: UILabel!
    var timerText : Int!
    
    override func viewDidLoad() {
        timer.text = "Final Time: \(timerText)"
    }
    
    
    @IBAction func backToMinigame(sender: AnyObject) {
    }
    @IBAction func restartGame(sender: AnyObject) {
    }

}
