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