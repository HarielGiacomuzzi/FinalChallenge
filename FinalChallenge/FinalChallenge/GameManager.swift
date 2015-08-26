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
    
    func selectPlayers(i:Int){
        var p = players[i]
        var aux = NSDictionary();
        aux.setValue(p.playerIdentifier, forKey: "playerID");
        aux.setValue(nil, forKey: "playerTurn");
        ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
}
    /*
    func cleanManager(){
        gameActive = ""
        playerRank.removeAll(keepCapacity: false)
        isMultiplayer = nil
    }*/
}