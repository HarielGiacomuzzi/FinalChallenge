//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController?
    let partsAtlas = SKTextureAtlas(named: "Board")
    
    override func didMoveToView(view: SKView) {
        GameManager.sharedInstance.boardViewController = self.viewController;
        let scaleFactorX = Double(2048/self.size.width);
        let scaleFactorY = Double(1536/self.size.height);
        
        for i in BoardGraph.SharedInstance.nodes{
            var texture = partsAtlas.textureNamed("square1");
            if i.0 == "House"{
                texture = partsAtlas.textureNamed("house");
            }
            if i.0 == "Store" {
                texture = partsAtlas.textureNamed("shop");
            }
            
            if i.1.nextMoves.count > 1 {
                texture = partsAtlas.textureNamed("square2");
            }
            
            let x = SKSpriteNode(texture: texture)
            x.position.x = CGFloat(i.1.posX/scaleFactorX);
            x.position.y = CGFloat(i.1.posY/scaleFactorY);
            x.size = CGSize(width: CGFloat(30), height: CGFloat(30));
            self.addChild(x);
        }
        
        let x = BoardGraph.SharedInstance.nodes["01"]?.posX;
        let y = BoardGraph.SharedInstance.nodes["01"]?.posY;
        
        for p in GameManager.sharedInstance.players{
            let sprite = SKSpriteNode(texture: partsAtlas.textureNamed("pin"))
            p.x = x;
            p.y = y;
            sprite.zPosition = 100;
            sprite.colorBlendFactor = 0.9;
            sprite.color = p.color;
            sprite.size = CGSize(width: 15, height: 20);
            p.nodeSprite = sprite;
            BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(p)
            
            self.addChild(p.nodeSprite!)
        }
        

        GameManager.sharedInstance.playerTurnEnded(nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
          //BoardGraph.SharedInstance.walk(1, player: realPlayer, view: self.viewController)
           //GameManager.sharedInstance.beginMinigame()
        
    }
    
    
    override func didFinishUpdate() {
        super.didFinishUpdate();
        for p in GameManager.sharedInstance.players{
            p.nodeSprite?.position.x = CGFloat(p.x/2);
            p.nodeSprite?.position.y = CGFloat(p.y/2);
        }
    }
}