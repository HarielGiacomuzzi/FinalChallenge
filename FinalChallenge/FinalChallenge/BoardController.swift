//
//  BoardController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/5/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class BoardController: SKScene, SKPhysicsContactDelegate {


class BoardGraph : NSObject{
    
    var nodes : [String : BoardNode] = [:];

    func loadBoard(fromFile : String){
        
    }
    
    // creates a node and insert it on the graph dictionary with the specified name
    private func createNode(x: Double, y : Double, name : String, father : BoardNode?){
        var aux = BoardNode(posX: x, posY: y, father: father);
        nodes.updateValue(aux, forKey: name);
    }
    
    private func setNeighbors(){
    
    }
    
    // returns the node name where the given player is located
    // if the player can't be found returns nil
    func whereIs(Player : NSObject) -> String?{
        for aux in nodes{
            if (aux.1.hasPlayer(Player)){
                return aux.0;
            }
        }
        return nil;
    }
    
    // returns the node where the given player is located
    // if the player can't be found returns nil
    func nodeFor(Player : NSObject) -> BoardNode?{
        for aux in nodes{
            if (aux.1.hasPlayer(Player)){
                return aux.1;
            }
        }
        return nil;
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
    
    func walk(quantity : Int){
    }
    
    private func sendPathChosenNotification(){
    
    }
    
    private func paintPaths(path : [String]){
    }
    
    func continueWalking(direction : String){
    }
    
    private func havePath(from : String, to : String){
    }
    
    private func gotoNode(){
    }
    
    class BoardNode : NSObject{
        var nextMoves : [BoardNode] = [];
        var posX = 0.0;
        var posY = 0.0;
        var item : NSObject?
        var currentPlayers : [NSObject] = [];
        var father : BoardNode?
        
        override init() {
            super.init();
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


}