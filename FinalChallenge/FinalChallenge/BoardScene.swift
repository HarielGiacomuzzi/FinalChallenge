//
//  BoardScene.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/18/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        var auxList = [SKNode?](count: self.children.count, repeatedValue: nil);
        
        println("<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n<BOARD>")
        
        for aux1 in self.children{
            var aux = aux1 as! SKNode;
            if aux.name != nil && aux.name == "house"{
                println("<HOUSE x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" father=\"nil\"/>");
            }
        }
        
        println("<NODES>");
        
        for aux1 in self.children{
            var aux = aux1 as! SKNode;
            
            if aux.name != nil && aux.name == "house"{
                continue
            }
            
            if aux.name != nil && aux.name == "store"{
                continue
            }
            
            auxList[(aux.name! as NSString).integerValue] = aux;
        }
        
        for node in auxList{
            if(node != nil){
                var aux = node as SKNode!
                println("<node x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" name=\"\(aux.name!)\" father=\"\((aux.name! as NSString).integerValue-1 )\">");
                println("<next name=\"\((aux.name! as NSString).integerValue+1 )\"/>");
                println("</node>")
            }
        }

        println("</NODES>");
        
        for aux1 in self.children{
            var aux = aux1 as! SKNode;
            if aux.name != nil && aux.name == "store"{
                println("<STORE x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" father=\"\"/>");
            }
        }

        println("</BOARD>")
    }
}
