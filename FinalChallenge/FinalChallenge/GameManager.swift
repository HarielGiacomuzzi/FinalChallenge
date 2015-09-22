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
    var isMultiplayer = false
    var players = [Player]()
    var totalGameTurns = 0
    var isOnMiniGame = false;
    var controlesDeTurno = 0
    
    //minigame controllers
    var minigameDescriptionViewController : MinigameDescriptionViewController?
    var minigameViewController : MiniGameViewController?
    var minigameGameOverViewController : MinigameGameOverController?
    var minigameGameOverViewControllerSinglePlayer : MinigameGameOverControllerSinglePlayer?
    
    var minigameOrderArray : [Minigame] = []
    var allMinigames : [Minigame] = [.FlappyFish, .BombGame]
    //var allMinigames : [Minigame] = [.FlappyFish]
    
    init(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DiceResult", object: nil);
    }
    
    // verifica se todos jogaram
    func playerTurnEnded(player : Player?){
        if controlesDeTurno >= players.count{
            //termina rodada
            controlesDeTurno = 0;
            self.isOnMiniGame = true;
            beginMinigame()
        }else{
            //controlesDeTurno = controlesDeTurno+1;
        }
        // proximo jogador
        controlesDeTurno = 0 // TIRAR ISSO AQUI, USADO APENAS PARA DEBUG
        selectPlayers(controlesDeTurno)
     }
    
    /*
    // dice responce
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
    }*/
    
    
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
        return Array(playerRank.reverse())
    }
    
    //your time bro
    func selectPlayers(i:Int){
        if !self.isOnMiniGame{
            controlesDeTurno++
            let p = players[i]
            let aux = NSMutableDictionary();
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
        self.isOnMiniGame = false;
        self.playerTurnEnded(nil);
        return Void()
        
        print("CHAMEI A FUNÇAO GO TO MINIGAME")
        print("O ARRAY TEM \(minigameOrderArray.count) ELEMENTOS")
        for m in minigameOrderArray {
            print(m.rawValue)
        }
        if minigameOrderArray.isEmpty {
            print("OPS, ESTAVA VAZIO, HEHEHE, VOU ENCHE-LO")
            fillMinigameOrderArray()
            print("O ARRAY AGORA TEM \(minigameOrderArray.count) ELEMENTOS")
            for m in minigameOrderArray {
                print(m.rawValue)
            }
        }
        let minigame = minigameOrderArray.randomItem()
        
        print("SERA QUE EU REMOVI UM ELEMENTO MESMO GALERA????")
        print("O ARRAY AGORA TEM \(minigameOrderArray.count) ELEMENTOS")
        for m in minigameOrderArray {
            print(m.rawValue)
        }
        
        print("O ELEMENTO ESCOLHIDO  R A N D O M I C A M E N T E  FOI O \(minigame.rawValue)")
        let dic = ["openController":"", "gameName":minigame.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        boardViewController?.performSegueWithIdentifier("gotoMinigame", sender: minigame.rawValue)

    }
    
    func pathChosen() {
        if isOnMiniGame {
        beginMinigame()
        }
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
        print("Cheguei aqui :P");
        let dic = ["closeController":" "]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        self.isOnMiniGame = false;
        self.playerTurnEnded(nil);
    }
    
    func dismissMinigameSP(){
        if let vc2 = self.minigameViewController {
            vc2.dismissViewControllerAnimated(false, completion: {() in
                if let vc3 = self.minigameDescriptionViewController {
                    vc3.dismissViewControllerAnimated(false, completion: nil)
                }
            })
        }
    }
    
    
    func dismissMinigameSinglePlayer(){
        if let vc = minigameGameOverViewControllerSinglePlayer {
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
        print("Cheguei aqui :P");
    }
    
    func updatePlayerMoney(player:Player, value:Int) ->Int{
        var aux = 0
        if value < 0 && player.coins < abs(value) {
            aux = player.coins
            player.coins = 0
        }else{
            aux = abs(value)
            player.coins += value
        }
        let playerData = ["player":player.playerIdentifier, "value": player.coins]
        let dic = ["updateMoney":" ", "dataDic" : playerData]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
        return aux
    }
    
}