//
//  GameManager.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameManager : NSObject {
    static let sharedInstance = GameManager()
    var miniGameActive = String()
    weak var boardViewController : UIViewController?
    var playerRank = [String]()
    var isMultiplayer = false
    var players = [Player]()
    var totalGameTurns = 0
    var currentGameTurn = 0
    var hasPath = false;
    var isOnMiniGame = false;
    var controlesDeTurno = 0
    var isOnBoard = false
    var isOnStore = false
    var gameEnded = false
    
    //used only in mainboard
    var doOnce = false
    
    //controllers acess
    weak var minigameDescriptionViewController : MinigameDescriptionViewController?
    weak var minigameViewController : MiniGameViewController?
    weak var boardGameViewController : BoardViewController?
    weak var ipadAvatarViewController : PartyModeViewControllerIPAD?

    // some arrays
    var minigameOrderArray : [Minigame] = []
    var allMinigames : [Minigame] = [.FlappyFish, .BombGame]
    //var allMinigames : [Minigame] = [.FlappyFish]
    
    override init(){
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "diceReceived:", name: "ConnectionManager_DiceResult", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mr3:", name: "ConnectionManager_SendCard", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerAskedToBuyCard:", name: "ConnectionManager_BuyCard", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "leaveStore:", name: "ConnectionManager_CloseStore", object: nil);
    }
    
    func restartGameManager(){
        self.doOnce = false
        self.players.removeAll()
        self.totalGameTurns = 0
        self.currentGameTurn = 0
        self.gameEnded = false
        self.isOnBoard = false
        self.hasPath = false
        self.isOnStore = false
        BoardGraph.SharedInstance.destroyGraph();
    }
    
    // verifica se todos jogaram
    func playerTurnEnded(player : Player?){
        if controlesDeTurno >= players.count{
            //termina rodada
            controlesDeTurno = 0;
            self.isOnMiniGame = true;
            if !hasPath && !isOnStore{
                beginMinigame()
            }
        }
        // proximo jogador
        selectPlayers(controlesDeTurno)
     }
    
    func playerTurn(player:Player?){
        let location = BoardGraph.SharedInstance.whereIs(player!)
        BoardGraph.SharedInstance.pickItem(location!, player: player!)
    }
    
    //dice responce
    func diceReceived(data : [String : NSObject]){
            for p in players{
                if p.playerIdentifier == (data["peerID"] as! String){
                    BoardGraph.SharedInstance.walk(data["diceResult"] as! Int, player: p, view: boardViewController);
                    playerTurn(p)
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
                BoardGraph.SharedInstance.setItem(setCard, nodeName: whereIsPlayer!) // return true if card was set
                break;
            }
        }
    }
    
    func playerAskedToBuyCard(data : NSNotification) {
        let playerName = data.userInfo!["peerID"] as! String
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let cardName = dic["card"] as! String
        
        print("player \(playerName) tried to buy card \(cardName)")
        
        let player = getPlayer(playerName)
        print(player.playerIdentifier)
        let card =  CardManager.ShareInstance.getCard(cardName)
        print(card.cardName)
        
        var status = " "
        var worked = false
        
        if player.items.count >= 5 {
            status = "You already have the maximum ammount of cards"
            print("ta lotado")
        } else if player.coins <= card.storeValue {
            status = "You don't have enough money"
            print("faltou money")
        } else {
            status = "You have successfully bought a card"
            worked = true
        }
        
        if worked {
            player.coins -= card.storeValue
            player.items.append(card)
            print("player comprou gostoso")
            print("player coins \(player.coins) | player items \(player.items)")
        }
        
        let dataDic = ["player":playerName, "status":status, "worked":worked, "playerMoney":player.coins, "card":cardName]
        let dicc = ["BuyResponse":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
        
    }
    
    func setPlayerOrder()->[String]{
        return Array(playerRank.reverse())
    }
    
    func endGameScene(){
        self.gameEnded = true
    }
    
    // handle player order
    func selectPlayers(i:Int){
        
        if self.currentGameTurn == self.totalGameTurns {
            //end game
            print("O jogo terminou tche")
            self.endGameScene()
        }
        
        if !self.isOnMiniGame{
            controlesDeTurno++
            let p = players[i]
            let aux = NSMutableDictionary();
            aux.setValue(p.playerIdentifier, forKey: "playerID");
            aux.setValue(" ", forKey: "playerTurn");
            ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
        }
    }
    
    // once reconected resends the message for the last player...
    func lostConnectionOnBoard(){
        let p = players[controlesDeTurno-1]
        let aux = NSMutableDictionary();
        aux.setValue(p.playerIdentifier, forKey: "playerID");
        aux.setValue(" ", forKey: "playerTurn");
        ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
    }
    
    // start minigame
    func beginMinigame() {

        self.currentGameTurn++
        
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
    
    // chamado quando o player já saiu da loja
    func leaveStore(){
        isOnStore = false
        if isOnMiniGame{
            beginMinigame()
        }
    }
    
    func fillMinigameOrderArray() {
        for minigame in allMinigames {
            minigameOrderArray.append(minigame)
        }
    }
    
    // MARK: - Dismiss views handlings
    
// dismiss the minigamescene and notificates the iPhone users the view change
    func dismissMinigameMP(){
        if let vc = self.minigameViewController {
            vc.dismissViewControllerAnimated(false, completion: nil)
            boardGameViewController?.viewDidLoad()
        }
        let dic = ["closeController":" "]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        self.isOnMiniGame = false;
        self.playerTurnEnded(nil);
    }
// this one may replace the dismissMinigameSP
    func newDismissMinigameSP(){
        if let vc = self.minigameViewController {
            vc.dismissViewControllerAnimated(false, completion: nil)
        }
    }
// dismiss boardgame view from the end game scene
    func dismissBoardGame(){
        if let vc = self.boardGameViewController {
            vc.dismissViewControllerAnimated(false, completion: nil)
            if let vc2 = self.ipadAvatarViewController {
                vc2.dismissViewControllerAnimated(false, completion: nil)
                
            }
        }
    }
    // MARK: - Card Functions
    
// used to update users gold or to use cards function, can take or give player gold
    func updatePlayerMoney(player:Player, value:Int) ->Int{
        var aux = 0
        if value < 0 && player.coins < abs(value) {
            aux = player.coins
            player.coins = 0
        }else{
            aux = abs(value)
            player.coins += value
        }
        //print("Esse é o jogador: \(player.playerIdentifier)")
        let playerData = ["player":player.playerIdentifier, "value": player.coins]
        let dic = ["updateMoney":" ", "dataDic" : playerData]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        return aux
    }
    
// update users position may be used with keyboard functions
    func updatePlayerPosition(move:Int, player:Player){
        BoardGraph.SharedInstance.walk(move, player: player, view: boardViewController);
    }
    

    // given a player name this function returns you the corresponding player
    func getPlayer(name:String) -> Player {
        for player in players {
            if player.playerIdentifier == name {
                return player
            }
        }
        return Player()
    }
        
}