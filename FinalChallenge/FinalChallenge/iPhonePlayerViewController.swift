//
//  iPhonePlayerViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import UIKit

class iPhonePlayerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerTurn:", name: "ConnectionManager_PlayerTurn", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openController:", name: "ConnectionManager_OpenController", object: nil);
    }
    
    func playerTurn(data : NSNotification){
        self.performSegueWithIdentifier("gotoDiceView", sender: nil)
        
    }
    
    func openController(data : NSNotification) {
        var gameData = data.userInfo!["gameName"] as! String
        var minigame = Minigame(rawValue: gameData)
        switch minigame! {
        case .FlappyFish:
            println("flappy")
        case .BombGame:
            println("bombgame")
        default:
            ()
        }
    }
}