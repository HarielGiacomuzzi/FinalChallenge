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
        
        print("<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n<BOARD>")
        
        for aux1 in self.children{
            let aux = aux1 ;
            if aux.name != nil && aux.name == "house"{
                print("<HOUSE x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" father=\"nil\"/>");
            }
        }
        
        print("<NODES>");
        
        for aux1 in self.children{
            let aux = aux1 ;
            
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
                let aux = node as SKNode!
                print("<node x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" name=\"\(aux.name!)\" father=\"\((aux.name! as NSString).integerValue-1 )\">");
                print("<next name=\"\((aux.name! as NSString).integerValue+1 )\"/>");
                print("</node>")
            }
        }

        print("</NODES>");
        
        for aux1 in self.children{
            let aux = aux1 ;
            if aux.name != nil && aux.name == "store"{
                print("<STORE x=\"\(aux.position.x)\" y=\"\(aux.position.y)\" father=\"\"/>");
            }
        }

        print("</BOARD>")
    }
    
    
}
