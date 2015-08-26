//
//  GameManager.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

class GameManager {
    static let sharedInstance = GameManager();
    var gameActive = String()
    var boardViewController : UIViewController?
    var playerRank = [String]()
    var isMultiplayer : Bool?
    var players = [Player]()
    
    init(){
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
    }
    
    func playerTurnEnded(player : Player){
      //chama aqui o próximo player :D 
    }
    
    func messageReceived(data : NSNotification){
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data.object as! NSData) as? NSDictionary{
            if message.valueForKey("diceResult") != nil {
                var diceResult = message.valueForKey("diceResult") as! Int;
                for p in players{
                    if p.playerIdentifier == (message.valueForKey("playerID") as! String){
                        BoardGraph.SharedInstance.walk(diceResult, player: p, view: boardViewController);
                        playerTurnEnded(p)
                        break;
                    }
                }
            }
        }
    }
    
    
    func setPlayerOrder()->[String]{
        return playerRank.reverse()
    }
    
    
    /*
    func cleanManager(){
        gameActive = ""
        playerRank.removeAll(keepCapacity: false)
        isMultiplayer = nil
    }*/
}