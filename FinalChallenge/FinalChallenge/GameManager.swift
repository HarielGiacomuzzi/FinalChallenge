//
//  GameManager.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class GameManager {
    static let sharedInstance = GameManager();
    var gameActive = String()
    var playerRank = [String]()
    var isMultiplayer : Bool?
    var players = [Player]()
    
    init(){

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