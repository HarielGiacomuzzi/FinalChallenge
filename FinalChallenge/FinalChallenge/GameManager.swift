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
    var currentGameTurn = 1
    var hasPath = false;
    var isOnMiniGame = false;
    var controlesDeTurno = 0
    var isOnBoard = false
    var isOnStore = false
    var gameEnded = false
    var dicex2 = false
    var escapeFlag = false
    var halfFlag = false
    var doubleDice = false
    
    //iphone only usage
    var playerColor = UIColor.clearColor()
    var activePlayer = [String]()
    
    //this variable is used to store the player movement while he is on store
    var movementClosure: () -> () = {}
    
    //used only in mainboard
    var doOnce = false
    
    //controllers acess
    weak var minigameDescriptionViewController : MinigameDescriptionViewController?
    weak var minigameViewController : MiniGameViewController?
    weak var boardGameViewController : BoardViewController?
    weak var ipadAvatarViewController : PartyModeViewControllerIPAD?
    weak var iphonePlayerController: iPhonePlayerViewController?
    
    // some arrays
    var minigameOrderArray : [Minigame] = []
    //var allMinigames : [Minigame] = [.FlappyFish, .BombGame]
    var allMinigames : [Minigame] = [.BombGame]
    
    override init(){
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "diceReceived:", name: "ConnectionManager_DiceResult", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cardReceived:", name: "ConnectionManager_SendCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerAskedToBuyCard:", name: "ConnectionManager_BuyCard", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "leaveStore:", name: "ConnectionManager_CloseStore", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addTrap:", name: "BoardNode_TrapAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeTrap:", name: "BoardNode_TrapRemoved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateCoinsAdded:", name: "Player_CoinsAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateCoinsRemoved:", name: "Player_CoinsRemoved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateCardAdded:", name: "Player_CardAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateCardRemoved:", name: "Player_CardRemoved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateIphoneColors:", name: "ConnectionManager_ColorSet", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setHalfMovement:", name: "ConnectionManager_HalfMove", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "set2Dice:", name: "ConnectionManager_DoubleMove", object: nil)
    }
    
    func restartGameManager(){
        self.doOnce = false
        self.players.removeAll()
        self.totalGameTurns = 0
        self.currentGameTurn = 1
        self.controlesDeTurno = 0
        self.gameEnded = false
        self.isOnBoard = false
        self.isOnMiniGame = false
        self.isMultiplayer = false
        self.playerRank.removeAll()
        self.activePlayer.removeAll()
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
        BoardGraph.SharedInstance.giveCoins(location!, player: player!)
    }
    
    //dice response
    func diceReceived(data : [String : NSObject]){
        
        var result = data["diceResult"] as! Int
        
        if (dicex2){
            result = result * 2
            dicex2 = false
        }
        for p in players{
            if p.playerIdentifier == (data["peerID"] as! String){
                boardGameViewController?.scene.showDiceNumber(result, player: p.nodeSprite!)
                let tuple = BoardGraph.SharedInstance.walkList(result, player: p, view: boardViewController)
                movePlayerOnBoardComplete(p, nodeList: tuple.nodeList, remaining: tuple.remaining, currentNode: tuple.currentNode)
                break;
            }
        }
    }
    
    //handles movement and all its possibilities
    func movePlayerOnBoardComplete(p:Player, nodeList:[BoardNode], remaining:Int,currentNode:BoardNode) {
        if remaining > 0 {
            if currentNode.isSpecialNode {
                movePlayerAndContinueWithSpecialNode(p, nodeList: nodeList, remaining: remaining, currentNode: currentNode)
            } else  if currentNode.nextMoves.count > 1 {
                movePlayerAndContinueWithCrossroads(p, nodeList: nodeList, remaining: remaining, currentNode: currentNode)
            }
            
        } else {
            movePlayerAndContinue(p, nodeList: nodeList)
        }
    }
    
    //ends movement and continues game
    func movePlayerAndContinue(p:Player, nodeList:[BoardNode]) {
        movePlayerOnBoard(nodeList, player: p, completion: {() in
            self.playerTurn(p)
            self.playerTurnEnded(p)
        })
    }
    
    //moves player until it gets to a special node, handles action and continues
    func movePlayerAndContinueWithSpecialNode(p:Player, nodeList:[BoardNode],remaining:Int,currentNode:BoardNode) {
        movePlayerOnBoard(nodeList, player: p, completion: {() in
            let nodeName = BoardGraph.SharedInstance.keyFor(currentNode)
            currentNode.activateNode(nodeName!, player: p)
            if nodeName != "Store" {
                self.movePlayerOneSquare(p, node: currentNode.nextMoves.first!, remaining: remaining)
            } else {
                self.movementClosure = {self.movePlayerOneSquare(p, node: currentNode.nextMoves.first!, remaining: remaining)}
            }
        })
    }
    
    //moves player until it gets to a crossroads then open alert to chose path and continues
    func movePlayerAndContinueWithCrossroads(p:Player, nodeList:[BoardNode], remaining:Int, currentNode:BoardNode) {
        movePlayerOnBoard(nodeList, player: p, completion: {() in
            let alert = AlertPath(title: "Select a Path", message: "Please Select a Path to Follow", preferredStyle: .Alert)
            for node in currentNode.nextMoves {
                let title = self.getRelativePosition(currentNode, node2: node)
                let action = UIAlertAction(title: title, style: .Default, handler: {action -> Void in
                    BoardGraph.SharedInstance.alertRef!.node = node
                    self.movePlayerOneSquare(p, node: node, remaining: remaining-1)
                })
                BoardGraph.SharedInstance.alertRef = alert
                BoardGraph.SharedInstance.alertCondition = true
                alert.addAction(action)
            }
            self.boardViewController?.presentViewController(alert, animated: true, completion:nil)

        })
        
    }
    
    func setHalfMovement(data:NSNotification){
        print("Caiu na half movement trap")
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let setHalfMove = dic["half"] as! Bool
        if UIDevice.currentDevice().name == playerName {
            print("Setou o halfflag para true")
            halfFlag = setHalfMove
        } else {
            print("Setou o halfflag para false")
            halfFlag = false
        }
    }
    
    func set2Dice(data:NSNotification){
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let playerName = dic["player"] as! String
        let setDoubleMovement = dic["double"] as! Bool
        if UIDevice.currentDevice().name == playerName {
            doubleDice = setDoubleMovement
        } else {
            doubleDice = false
        }
    }
    
    func getRelativePosition(node1:BoardNode, node2:BoardNode) -> String {
        let leftRight = fabs(fabs(node1.posX) - fabs(node2.posX))
        let upDown = fabs(fabs(node1.posY) - fabs(node2.posY))
        if leftRight > upDown {
            if node2.posX > node1.posX {
                return "right"
            } else {
                return "left"
            }
        } else {
            if node2.posY > node1.posY {
                return "up"
            } else {
                return "down"
            }
        }
    }
    
    //moves player one block ahead
    func movePlayerOneSquare(p:Player, node:BoardNode, remaining:Int) {
        BoardGraph.SharedInstance.walkToNode(p, node: node)
        movePlayerOnBoard([node], player: p, completion: {() in
            let tuple = BoardGraph.SharedInstance.walkList(remaining, player: p, view: self.boardViewController)
            self.movePlayerOnBoardComplete(p, nodeList: tuple.nodeList, remaining: tuple.remaining, currentNode: tuple.currentNode)
        })
    }
    
    func movePlayerBack(p: Player, distance: Int) {
        BoardGraph.SharedInstance.walkBackwards(p, distance: distance)
    }
    

    // manda a carta a ser adicionada no boardGame
    func cardReceived(data : NSNotification){
        
        guard !players.isEmpty else {
            return
        }
        
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        
        var status = " "
        var sent = false
        let playerName = data.userInfo!["peerID"] as! String
        
        for p in players{
            if p.playerIdentifier == (data.userInfo!["peerID"] as! String){
                let card = dic["item"] as! String
                for c in p.items{
                    if card == c.cardName {
                        if let activeCard = c as? ActiveCard {
                            let whereIsPlayer = BoardGraph.SharedInstance.whereIs(p)
                            activeCard.used = true
                            if(activeCard.trap){
                                if BoardGraph.SharedInstance.setItem(activeCard, nodeName: whereIsPlayer!) {
                                    p.items.removeObject(c)
                                    activeCard.used = true
                                    activeCard.cardOwner = p
                                    sent = true
                                    status = "trapSetUp"
                                } else {
                                    activeCard.used = false
                                    status = "cardBadSpot"
                                }
                            } else {
                                sent = true
                                // case not trap
                                switch(activeCard.cardName){
                                case "Double Speed": let card = activeCard as! DoubleSpeed
                                                     card.activate(p)
                                case "Escape Traps": let card = activeCard as! EscapeTraps
                                                     card.activate(p)
                                case "Extra Dice": let card = activeCard as! ExtraDice
                                                     card.activate(p)
                                default : break
                                }
                                p.items.removeObject(c)
                            }
                        }
                        if let _ = c as? NotActiveCard {
                            status = "cardWrongCard"
                        }
                        break
                    }
                }
                break
            }
        }
        let item = dic["item"] as! String
        let dataDic = ["sent":sent, "status": status, "item": item, "playerName": playerName]
        let dicc = ["removeCard":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
        
    }
    
    func removeCard(player: Player, item: Card) {
        let dataDic = ["playerName": player.playerIdentifier, "item": item.cardName, "sent": true, "status": "cardCastle"]
        let dicc = ["removeCard":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
    }
    
    func playerAskedToBuyCard(data : NSNotification) {
        let playerName = data.userInfo!["peerID"] as! String
        let dic = data.userInfo!["dataDic"] as! NSDictionary
        let cardName = dic["card"] as! String
        
        guard !players.isEmpty else {
            return
        }
        
        let player = getPlayer(playerName)
        let card =  CardManager.ShareInstance.getCard(cardName)
        
        var status = " "
        var worked = false
        
        if player.items.count >= 5 {
            status = "buyMaxCards"
        } else if player.coins <= card.storeValue {
            status = "buyNoMoney"
        } else {
            status = "buySuccess"
            worked = true
        }
        
        if worked {
            player.coins -= card.storeValue
            player.items.append(card)
        }
        
        let dataDic = ["player":playerName, "status":status, "worked":worked, "playerMoney":player.coins, "card":cardName]
        let dicc = ["BuyResponse":" ","dataDic":dataDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dicc, reliable: true)
        
    }
    
    func setPlayerOrder()->[String]{
        return Array(playerRank.reverse())
    }
    
    func endGameScene(){
        print("Chamaram o fim de jogo")
        self.gameEnded = true
        let end = "gameEnded"
        let e = ["gameEnded":end]
        let dic = ["TheGameEnded": " ", "gameEnded":e]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    // handle player order
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
        sendBeginMinigameMessage(minigame)
        boardViewController?.performSegueWithIdentifier("gotoMinigame", sender: minigame.rawValue)

    }
    
    func sendBeginMinigameMessage(minigame:Minigame) {
        var playerColorDic:[String:UIColor] = [:]
        for player in players {
            playerColorDic[player.playerIdentifier] = player.color
        }

        let dic = ["openController":"", "gameName":minigame.rawValue, "playerColorDic":playerColorDic]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    // chamado quando o player já escolheu um caminho no tabuleiro
    func pathChosen() {
        if isOnMiniGame {
            beginMinigame()
        }
    }
    
    // chamado quando o player já saiu da loja
    func leaveStore(data:NSNotification){
        movementClosure()
        isOnStore = false
        if isOnMiniGame {
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
        
        if self.currentGameTurn == self.totalGameTurns {
            //end game
            self.endGameScene()
        }
        
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
// Dismiss player controller on iphone
    func dismissPlayerViewController(){
        //print("dismissPlayerViewController")
        if let vc = self.iphonePlayerController{
            vc.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    
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
        let playerData = ["player":player.playerIdentifier, "value": player.coins]
        let dic = ["updateMoney":" ", "dataDic" : playerData]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        return aux
    }
    
    // used to update users loot
    func updatePlayerLoot(player:Player, value:Int) ->Int{
        var aux = 0
        if value < 0 && player.lootPoints < abs(value) {
            aux = player.lootPoints
            player.lootPoints = 0
        }else{
            aux = abs(value)
            player.lootPoints += value
        }
        let playerData = ["player":player.playerIdentifier, "value": player.lootPoints]
        let dic = ["updateLoot":" ", "dataDic" : playerData]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        return aux
    }
    
    func sendPlayersColors(){
        let arrayColor = self.activePlayer
        let array = ["arrayColor":arrayColor]
        let dic = ["ColorSet":" ", "arrayColor":array]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    
    func updateIphoneColors(data: NSNotification){
        let dictionary = data.userInfo!["arrayColor"] as! NSDictionary
        let arr = dictionary["arrayColor"] as! [String]
        
        self.activePlayer = arr
        
        print("Array: \(self.activePlayer)")
       
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
    
    func movePlayerOnBoard(nodes:[BoardNode], player: Player, completion:() -> ()) {
        var points:[CGPoint] = []
        for n in nodes {
            points.append(CGPointMake(CGFloat(n.posX), CGFloat(n.posY)))
        }
        player.nodeSprite?.walkTo(points, completion: completion)
        
    }
    
    func addTrap(data: NSNotification) {
        print("addtrap")
        let boardNode = data.object as! BoardNode
        print(boardNode)
        boardGameViewController?.scene.addTrap(CGFloat(boardNode.posX), y: CGFloat(boardNode.posY))
    }
    
    func removeTrap(data: NSNotification) {
        let boardNode = data.object as! BoardNode
        boardGameViewController?.scene.removeTrap(CGFloat(boardNode.posX), y: CGFloat(boardNode.posY))
    }
    
    func animateCoinsAdded(data: NSNotification) {
        let player = data.object as! Player
        if let scene = boardGameViewController?.scene {
            print("mandei")
            scene.showMoney(player.nodeSprite!, good:true)
        }
    }
    
    func animateCoinsRemoved(data: NSNotification) {
        let player = data.object as! Player
        if let scene = boardGameViewController?.scene {
            scene.showMoney(player.nodeSprite!, good:false)
        }
    }
    
    func animateCardAdded(data: NSNotification) {
        let player = data.object as! Player
        if let scene = boardGameViewController?.scene {
            scene.showCard(player.nodeSprite!, good: true)
        }
    }
    
    func animateCardRemoved(data: NSNotification) {
        let player = data.object as! Player
        if let scene = boardGameViewController?.scene {
            scene.showCard(player.nodeSprite!, good: false)
        }
    }
    
    func playerHoldingBomb(player:String){
        let p = player
        let swipe = ["lightSwipe":p]
        let dic = ["SwipeActive":" ", "lightSwipe":swipe]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
        //print("Array: \(self.activePlayer)")
    }
    
    func updatePlayerInformation(name:String){
        var aux = Player()
        for p in players{
            if p.playerIdentifier == name {
                aux = p
                break
            }
        }
        self.updatePlayerMoney(aux, value: 0)
        self.updatePlayerLoot(aux, value: 0)
    }
        
}