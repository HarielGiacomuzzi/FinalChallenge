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

    func loadBoard(fromFile : String){
        let a = XMLParser();
        a.loadBoardFrom(NSBundle.mainBundle().pathForResource(fromFile, ofType: "xml")!);
    }
    
    // returns the total amount of nodes
    func getNodesCount()->Int{
        return nodes.count;
    }
    
    // creates a node and insert it on the graph dictionary with the specified name
    func createNode(x: Double, y : Double, name : String?, father : BoardNode?){
        let aux = BoardNode(posX: x, posY: y, father: father);
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
    
    // returns the item of the specified node or nil if there's no item on that node
    func getItem(nodeName : String) -> NSObject?{
        if haveItem(nodeName) {
            return nodes[nodeName]?.item;
        }
        return nil;
    }
    
    // sets the item of a node, return true if it was successfull and false otherwise
    func setItem(Item : NSObject, nodeName : String) ->Bool{
        if !haveItem(nodeName){
            nodes[nodeName]?.item = Item;
            return true;
        }
        return false;
    }
    
    
    private func walkRecursivo(qtd : Int, node : BoardNode) -> [BoardNode]{
        var lista : [BoardNode] = [];
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
    
    func walk(qtd : Int, player : Player, view : UIViewController?){
        let playerLastNode = nodeFor(player)
        var x : [BoardNode] = walkRecursivo(qtd, node: playerLastNode!)
        playerLastNode?.removePlayer(player);
        
        if x.count > 1{
            let alerta = AlertPath(title: "Select a Path", message: "escolhe ai fera!", preferredStyle: .Alert)
            for i in x{
                let action = UIAlertAction(title: "Path: \(keyFor(i))", style: .Default) { action -> Void in
                    player.x = i.posX
                    player.y = i.posY
                    i.insertPLayer(player)
                }
                    alerta.addAction(action)
                }
            view?.presentViewController(alerta, animated: true, completion: nil)
        }else{
            let i = x[0]
            player.x = i.posX
            player.y = i.posY
            i.insertPLayer(player);
        }
    
    }
    
    private func paintPaths(path : [String]){
    }
    
    class BoardNode : NSObject{
        var nextMoves : [BoardNode] = [];
        var posX = 0.0;
        var posY = 0.0;
        var item : NSObject?
        var nextNames : [String] = [];
        var currentPlayers : [Player] = [];
        var father : BoardNode?
        
        override init() {
            super.init();
        }
        
        func hasNext(node : BoardNode) -> Bool{
            for x in nextMoves{
                if x == node{
                    return true;
                }
            }
            return false;
        }
        
        func removePlayer(player : Player?){
            currentPlayers.removeObject(player!);
        }
        
        func insertPLayer(player : Player?){
            currentPlayers.append(player!);
        }
        
        func hasPlayer(player : NSObject) -> Bool{
            for aux in currentPlayers{
                if aux.isEqual(player){
                    return true;
                }
            }
            
            return false;
        }
        
        init(posX : Double, posY : Double, father : BoardNode?) {
            super.init();
            self.father = father;
            self.posX = posX;
            self.posY = posY;
            
        }
    }
    
}