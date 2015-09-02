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
    var isOnMiniGame = false;
    var controlesDeTurno = 0
    
    //minigame controllers
    var minigameDescriptionViewController : MinigameDescriptionViewController?
    var minigameViewController : MiniGameViewController?
    var minigameGameOverViewController : MinigameGameOverController?
    
    var minigameOrderArray : [Minigame] = []
    var allMinigames : [Minigame] = [.FlappyFish]
    
    init(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DiceResult", object: nil);
    }
    
    func playerTurnEnded(player : Player?){
        if controlesDeTurno >= players.count{
            controlesDeTurno = 0;
            self.isOnMiniGame = true;
            beginMinigame()
        }else{
            //controlesDeTurno = controlesDeTurno+1;
        }
        selectPlayers(controlesDeTurno)
     }
    
    func messageReceived(data : NSNotification){
        if let result = (data.userInfo!["diceResult"] as? Int){
            for p in players{
                if p.playerIdentifier == (data.userInfo!["peerID"] as! String){
                    BoardGraph.SharedInstance.walk(result, player: p, view: boardViewController);
                    if !self.isOnMiniGame{
                        playerTurnEnded(p)
                    }
                    break;
                }
            }
        }
    }
    
    func messageReceived(data : [String : NSObject]){
            for p in players{
                if p.playerIdentifier == (data["peerID"] as! String){
                    BoardGraph.SharedInstance.walk(data["diceResult"] as! Int, player: p, view: boardViewController);
                    playerTurnEnded(p)
                    break;
                }
            }
    }
    
    
    func setPlayerOrder()->[String]{
        return playerRank.reverse()
    }
    
    func selectPlayers(i:Int){
        if !self.isOnMiniGame{
            controlesDeTurno++
            var p = players[i]
            var aux = NSMutableDictionary();
            aux.setValue(p.playerIdentifier, forKey: "playerID");
            aux.setValue(" ", forKey: "playerTurn");
            ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
        }
    }
    
    /*
    func cleanManager(){
        gameActive = ""
        playerRank.removeAll(keepCapacity: false)
        isMultiplayer = nil
    }*/
    
    func beginMinigame() {
        println("CHAMEI A FUNÇAO GO TO MINIGAME")
        println("O ARRAY TEM \(minigameOrderArray.count) ELEMENTOS")
        for m in minigameOrderArray {
            println(m.rawValue)
        }
        if minigameOrderArray.isEmpty {
            println("OPS, ESTAVA VAZIO, HEHEHE, VOU ENCHE-LO")
            fillMinigameOrderArray()
            println("O ARRAY AGORA TEM \(minigameOrderArray.count) ELEMENTOS")
            for m in minigameOrderArray {
                println(m.rawValue)
            }
        }
        var minigame = minigameOrderArray.randomItem()
        
        println("SERA QUE EU REMOVI UM ELEMENTO MESMO GALERA????")
        println("O ARRAY AGORA TEM \(minigameOrderArray.count) ELEMENTOS")
        for m in minigameOrderArray {
            println(m.rawValue)
        }
        
        println("O ELEMENTO ESCOLHIDO  R A N D O M I C A M E N T E  FOI O \(minigame.rawValue)")
        var dic = ["openController":"", "gameName":minigame.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        boardViewController?.performSegueWithIdentifier("gotoMinigame", sender: minigame.rawValue)

    }
    
    func fillMinigameOrderArray() {
        for minigame in allMinigames {
            minigameOrderArray.append(minigame)
        }
    }
    
    func dismissMinigame() {
        if let vc = minigameGameOverViewController {
            vc.dismissViewControllerAnimated(false, completion: {() in
                if let vc2 = self.minigameViewController {
                    vc2.dismissViewControllerAnimated(false, completion: {() in
                        if let vc3 = self.minigameDescriptionViewController {
                            vc3.dismissViewControllerAnimated(false, completion: nil)
                        }
                    })
                }
            })
            //selectPlayers(0);
        }
        println("Cheguei aqui :P");
        var dic = ["closeController":" "]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        self.isOnMiniGame = false;
        self.playerTurnEnded(nil);
    }
    
}