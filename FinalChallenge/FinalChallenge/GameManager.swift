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
    static let sharedInstance = GameManager()
    var miniGameActive = String()
    var boardViewController : UIViewController?
    var playerRank = [String]()
    var isMultiplayer : Bool?
    var players = [Player]()
    var controlesDeTurno = 0
    
    init(){
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil);
    }
    
    func playerTurnEnded(player : Player?){
      //chama aqui o próximo player :D controlar ternario Hariel :D
        controlesDeTurno >= 1 ? 0 : controlesDeTurno++
        selectPlayers(controlesDeTurno)
     }
    
//    func messageReceived(data : NSNotification){
//        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data.userInfo!["data"] as! NSData) as? NSDictionary{
//            if message.valueForKey("diceResult") != nil {
//                var diceResult = message.valueForKey("diceResult") as! Int;
//                for p in players{
//                    if p.playerIdentifier == (message.valueForKey("playerID") as! String){
//                        BoardGraph.SharedInstance.walk(diceResult, player: p, view: boardViewController);
//                        playerTurnEnded(p)
//                        break;
//                    }
//                }
//            }
//        }
//    }
    
    
    func setPlayerOrder()->[String]{
        return playerRank.reverse()
    }
    
    func selectPlayers(i:Int){
        var p = players[i]
        var aux = NSMutableDictionary();
        aux.setValue(p.playerIdentifier, forKey: "playerID");
        aux.setValue(" ", forKey: "playerTurn");
        ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
    }
    
    /*
    func cleanManager(){
        gameActive = ""
        playerRank.removeAll(keepCapacity: false)
        isMultiplayer = nil
    }*/
}