//
//  BoardController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/5/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class BoardGraph : NSObject{
    
    static let SharedInstance = BoardGraph();
    var nodes : [String : BoardNode] = [:];
    private var hasSpecialNodeOnPath = false;
    private var specialNodeName = "";
    var alertCondition = false;
    var alertRef : AlertPath?
    
    
    func loadBoard(fromFile : String){
        let a = XMLParser();
        a.loadBoardFrom(NSBundle.mainBundle().pathForResource(fromFile, ofType: "xml")!);
    }
    
    // returns the total amount of nodes
    func getNodesCount()->Int{
        return nodes.count;
    }
    
    // kill's em all
    func destroyGraph(){
        for x in nodes{
            x.1.item = nil;
            x.1.coins = nil;
            x.1.father = nil;
            x.1.nextMoves = [];
        }
        nodes = [:];
    }
    
    // creates a node and insert it on the graph dictionary with the specified name
    func createNode(x: Double, y : Double, name : String?, father : BoardNode?){
        let aux = BoardNode(posX: x, posY: y, father: father);
        let predicate =  NSPredicate(format:"SELF MATCHES %@", "[A-Za-z]{2,5}[0-9]?")
        if predicate.evaluateWithObject(name!){
            aux.isSpecialNode = true;
        }
        nodes.updateValue(aux, forKey: name!);
    }
    
    func setNeighborsReference(){
        for aux in nodes{
            for x in aux.1.nextNames{
                if !aux.1.hasNext(nodes[x]!){
                    aux.1.nextMoves.append(nodes[x]!)
                }
//                println("from : \(aux.0) to : \(x)");
            }
            removeItemFromInappropriatePlace();
            addCoins()
        }
    }
    
    // sets the next node on the graph
    func setNeighbors(currentNode : String, nextNode : String ){
        if nodes[currentNode] != nil && nodes[nextNode] != nil {
            nodes[currentNode]?.nextMoves.append(nodes[nextNode]!);
        }
        if nodes[currentNode] != nil {
            nodes[currentNode]?.nextNames.append(nextNode);
        }
    }
    
    // returns the node name where the given player is located
    // if the player can't be found returns nil
    func whereIs(player : Player) -> String?{
        for aux in nodes{
            if (aux.1.hasPlayer(player)){
                return aux.0;
            }
        }
        return nil;
    }
    
    // returns the node where the given player is located
    // if the player can't be found returns nil
    func nodeFor(player : Player) -> BoardNode?{
        for aux in nodes{
            if (aux.1.hasPlayer(player)){
                return aux.1;
            }
        }
        return nil;
    }

    func keyFor(node : BoardNode) -> String?{
        for aux in nodes{
            if (aux.1 == node){
                return aux.0;
            }
        }
        return nil;
    }
    
    func setFather(fatherName : String?, sonName : String!) -> Bool{
        if nodes[fatherName!] != nil && nodes[sonName] != nil {
            nodes[sonName]?.father = nodes[fatherName!];
            return true;
        }
        return false;
    }

    // check if there's an item on that node...
    func haveItem(NodeName : String) ->Bool{
        if nodes[NodeName]?.item != nil{
            return true;
        }
        return false;
    }
    
    func isUsable(nodeName:String)->Bool{
        if nodes[nodeName]?.item!.usable == true{
            return true
        }
        return false
    }
    
    func wasUsed(nodeName:String)->Bool{
        let card = nodes[nodeName]?.item as! ActiveCard
        if card.used{
            return true
        }
        return false
    }
    
    // returns the item of the specified node or nil if there's no item on that node
    func getItem(nodeName : String) -> NSObject?{
        if haveItem(nodeName) {
            return nodes[nodeName]?.item;
        }
        return nil;
    }
    
    // sets the item of a node, return true if it was successfull and false otherwise
    func setItem(Item : Card, nodeName : String) ->Bool{
        if !haveItem(nodeName){
            //print("Colocou a carta \(Item.cardName)")
            nodes[nodeName]?.item = Item
            return true
        }
        return false
    }
    
    // inform the player witch card he got from the boardNode
    func sendCardToPlayer(nodeName : String, player:Player){
        let card = nodes[nodeName]!.item
        if player.items.count < 5 {
            player.items.append(card!)
            
            let cardData = ["player":player.playerIdentifier, "item": card!.cardName]
            let dic = ["addCard":" ", "dataDic" : cardData]
            
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
            nodes[nodeName]?.item = nil
        }
        
    }
    
    //removes item from node and adds item to player
    //sends message to player phone to update item
    func pickItem(nodeName : String, player:Player) -> Bool{
        if haveItem(nodeName) {
            if !isUsable(nodeName){
                self.sendCardToPlayer(nodeName, player: player)
                //print("Entregou ao jogador a carta não usavel")
            } else{
                if !wasUsed(nodeName){
                    self.sendCardToPlayer(nodeName, player: player)
                    //print("Entregou ao jogador a carta usavel, que ainda não foi usada")
                } else{
                    // caso a carta ja tenha sido usada ela ativa seu efeito
                    //print("A carta era usavel e está sendo usada")
                    if !GameManager.sharedInstance.escapeFlag{
                        self.activateCard((nodes[nodeName]?.item)! as! ActiveCard, targetPlayer: player)
                        nodes[nodeName]?.item = nil
                        GameManager.sharedInstance.animatePlayerOnTrap(player)
                    } else {
                        // faz algo se o jogador escapou da trap
                        GameManager.sharedInstance.escapeFlag = false
                    }
                }
            }
            
            //print(player.items)
            
            return true
        }
        return false;
    }
    
    //gives the house cois to player and sets it to 0
    func giveCoins(nodeName : String, player : Player) {
        if nodes[nodeName]?.coins > 0 {
            GameManager.sharedInstance.updatePlayerMoney(player, value: nodes[nodeName]!.coins!)
        }
        nodes[nodeName]?.coins = 0
    }
    
    // activate cards funcions
    func activateCard(card:ActiveCard, targetPlayer:Player){
        switch(card.cardName){
            // each card has a type and a name, convert the card to its type by its name
            case "StealGoldCard" :  //print("Fez o efeito da carta StealGoldCard")
                                    let actionCard = card as! StealGoldCard
                                    actionCard.activate(targetPlayer)
            case "MoveBackCard" :   //print("Fez o efeito da carta MoveBackCard")
                                    let actionCard = card as! MoveBackCard
                                    actionCard.activate(targetPlayer)
            case "LoseCard" :       //print("Fez o efeito da carta LoseCard")
                                    let actionCard = card as! LoseCard
                                    actionCard.activate(targetPlayer)
            case "Half Speed" :
                                    let actionCard = card as! HalfSpeed
                                    actionCard.activate(targetPlayer)
            default: break
        }
    }
    
    func addCoins(){
        let aux = Array(nodes.values)
        for _ in 0...Int(arc4random_uniform(50)+1){
            if !aux[Int(arc4random_uniform(UInt32(aux.count)))].isSpecialNode{
                aux[Int(arc4random_uniform(UInt32(aux.count)))].coins = Int(arc4random_uniform(9)+1)*5
            
            }
        }
    }
   
    
    
    /* ******************************** */
    /* WALK ATUAL ESTA AQUI !!!!!!!! */
    /* ******************************** */
    
    private func walk(quantity : Int, node : BoardNode, var list : [BoardNode], view : UIViewController?) -> (nodeList:[BoardNode], remaining:Int, currentNode:BoardNode){

        if quantity == 0 || node.nextMoves.count > 1 || node.isSpecialNode {
            return (list, quantity, node)
        }
        
        list.append(node.nextMoves.first!)
        return walk(quantity - 1, node: node.nextMoves.first!, list : list, view: view);
    }
    
    //returns the list of nodes the player have moved
    func walkList(quantity : Int, player : Player, view : UIViewController?) -> (nodeList:[BoardNode], remaining:Int, currentNode:BoardNode){

        let a = walk(quantity, node: nodeFor(player)!, list: [], view: view);
        nodeFor(player)?.removePlayer(player);
        a.nodeList.last?.insertPLayer(player);
        return a;
    }
    
    //used to move to the next node in cases you have to choose, or when you're blocked
    func walkToNode(player:Player, node:BoardNode) {
        nodeFor(player)?.removePlayer(player)
        node.insertPLayer(player)
    }
    
    //TODO: walk backwards
    
    func walkBackwards(player:Player, var distance: Int) {
        print("vou printar os pais")
        for node in nodes {
            print(node.1.father)
        }
//        var node = nodeFor(player)
//        print(node)
//        while distance > 0 {
//            node = node?.father
//            print(node)
//            distance--
//        }
//        nodeFor(player)?.removePlayer(player)
//        node!.insertPLayer(player)
    }
    
    
    /* ******************************** */
    /* WALK ATUAL TERMINA AQUI !!!!!!!! */
    /* ******************************** */
    
    
    
    // Recursive* not Recursivo
    private func walkRecursivo(qtd : Int, node : BoardNode) -> [BoardNode]{
        var lista : [BoardNode] = [];
        if node.isSpecialNode{
            hasSpecialNodeOnPath = true;
            specialNodeName = keyFor(node)!;
        }
        if qtd == 0{
            lista.append(node)
            return lista
        }
        
        for nodeAux in node.nextMoves{
            for j in walkRecursivo(qtd-1, node: nodeAux){
                lista.append(j)
            }
        }
        return lista
    }
    
    // Jhonny Walker keep walking
    func walk(qtd : Int, player : Player, view : UIViewController?){
        if qtd < 0{
            walkBackward(qtd, player:player)
            return
        }
        var playerLastNode = nodeFor(player)
        var x : [BoardNode] = walkRecursivo(qtd, node: playerLastNode!)
        for i in x {
            print(keyFor(i));
        }
        if hasSpecialNodeOnPath{
            nodes[specialNodeName]?.insertPLayer(player);
            playerLastNode?.removePlayer(player);
            playerLastNode = nodes[specialNodeName];
            nodes[specialNodeName]?.activateNode(specialNodeName, player: player);
        }
        if x.count > 1{
            let alerta = AlertPath(title: "Select a Path", message: "Please Select a Path to Follow", preferredStyle: .Alert)
            GameManager.sharedInstance.hasPath = true;
            for i in x{
                let action = UIAlertAction(title: "Path: \(keyFor(i))", style: .Default) { action -> Void in
                    player.x = i.posX
                    player.y = i.posY
                    i.insertPLayer(player)
                    playerLastNode?.removePlayer(player);
                }
                    alerta.addAction(action)
                }
            view?.presentViewController(alerta, animated: true, completion: nil)
        }else{
            let i = x[0]
            player.x = i.posX
            player.y = i.posY

            i.insertPLayer(player);
            playerLastNode?.removePlayer(player);
        }
    }
    
    func walkBackward(qtd : Int, player : Player){
        let aux = Int(whereIs(player)!);
        nodes[whereIs(player)!]?.removePlayer(player)
        if aux! - qtd < 0{
        return Void()
        } else{
           let x = nodes[String(aux!-qtd)]
            player.x = x!.posX
            player.y = x!.posY
            x!.insertPLayer(player);
        }
    }
    
    func removeItemFromInappropriatePlace(){
        for i in nodes{
            if i.1.isSpecialNode{
                i.1.item = nil;
            }
        }
    }
}
