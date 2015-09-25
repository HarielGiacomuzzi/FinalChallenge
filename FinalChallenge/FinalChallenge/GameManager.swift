//
//  GameManager.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

class GameManager : NSObject {
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
    //var allMinigames : [Minigame] = [.FlappyFish, .BombGame]
    var allMinigames : [Minigame] = [.FlappyFish]
    
    override init(){
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DiceResult", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived2:", name: "ConnectionManager_EndAction", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mr3:", name: "ConnectionManager_SendCard", object: nil);
    }
    
    // verifica se todos jogaram
    func playerTurnEnded(player : Player?){
        if controlesDeTurno >= players.count{
            //termina rodada
            controlesDeTurno = 0;
            self.isOnMiniGame = true;
            beginMinigame()
        }
        // proximo jogador
        selectPlayers(controlesDeTurno)
     }
    
    func playerTurn(player:Player?){
        let location = BoardGraph.SharedInstance.whereIs(player!)
        _ = BoardGraph.SharedInstance.pickItem(location!, player: player!)
    }
    
    //dice responce
    func messageReceived(data : [String : NSObject]){
            for p in players{
                if p.playerIdentifier == (data["peerID"] as! String){
                    BoardGraph.SharedInstance.walk(data["diceResult"] as! Int, player: p, view: boardViewController);
                    playerTurnEnded(p)
                    playerTurn(p)
                    break;
                }
            }
    }
    // Finaliza turno
    func messageReceived2(data : [String : NSObject]){
        for p in players{
            if p.playerIdentifier == (data["peerID"] as! String){
                playerTurnEnded(p)
                break;
            }
        }
    }
    // manda a carta a ser adicionada no boardGame
    func mr3(data : NSNotification){
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        
        for p in players{
            if p.playerIdentifier == (data.userInfo!["peerID"] as! String){
                let card = dic["item"] as! String
                var setCard = ActiveCard()
                for c in p.items{
                    if card == c.cardName{
                        p.items.removeObject(c)
                        setCard = c as! ActiveCard
                        setCard.used = true
                        setCard.cardOwner = p
                        break
                    }
                }
                let whereIsPlayer = BoardGraph.SharedInstance.whereIs(p)
                _ = BoardGraph.SharedInstance.setItem(setCard, nodeName: whereIsPlayer!) // return true if card was set
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
    
    // acabou a rodada, está na hora da aventura :P
    func beginMinigame() {
        //self.isOnMiniGame = false;
        //self.playerTurnEnded(nil);
        //return Void()

        if minigameOrderArray.isEmpty {
            fillMinigameOrderArray()
        }
        let minigame = minigameOrderArray.randomItem()
        for m in minigameOrderArray {
            print(m.rawValue)
        }
        
        let dic = ["openController":"", "gameName":minigame.rawValue]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        boardViewController?.performSegueWithIdentifier("gotoMinigame", sender: minigame.rawValue)

    }
    
    // chamado quando o player já escolheu um caminho no tabuleiro
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
    
    // chama isso quando termina o minigame e inicia a próxima rodada
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
        let dic = ["closeController":" "]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        self.isOnMiniGame = false;
        //self.playerTurnEnded(nil);
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
        print("Esse é o jogador: \(player.playerIdentifier)")
        let playerData = ["player":player.playerIdentifier, "value": player.coins]
        let dic = ["updateMoney":" ", "dataDic" : playerData]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
        return aux
    }
    
    func updatePlayerPosition(move:Int, player:Player){
        BoardGraph.SharedInstance.walk(move, player: player, view: boardViewController);
    }
    
    func loseCard(player:Player){
        let value = player.items.count
        let indexCard : Int = (random() % value)
        player.items.removeAtIndex(indexCard)
        
        let removedCard = player.items[indexCard]
        let cardData = ["player":player.playerIdentifier, "item": removedCard]
        let dic = ["removeCard":" ", "dataDic" : cardData]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
}