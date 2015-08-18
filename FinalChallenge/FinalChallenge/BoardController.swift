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
    
    private func createNode(x: Double, y : Double){
        
    }
    
    private func setNeighbors(){
    
    }
    
    func whereIs(Player : NSObject){
    
    }
    
    func nodeFor(Player : NSObject){
    }
    
    func haveItem(NodeName : String) {
    }
    
    func getItem(nodeName : String){
    }
    
    func setItem(Item : NSObject, nodeName : String){
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
        var item : NSObject!
        var currentPlayers : [NSObject] = [];
        var father : BoardNode!
        
        override init() {
            super.init();
        }
        
        init(posX : Double, posY : Double) {
            super.init();
            self.posX = posX;
            self.posY = posY;
            
        }
    }
    
}


}