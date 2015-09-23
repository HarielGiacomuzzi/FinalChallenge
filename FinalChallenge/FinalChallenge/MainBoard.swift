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
    var realPlayer : Player?
    let partsAtlas = SKTextureAtlas(named: "Board")
    
    override func didMoveToView(view: SKView) {
        GameManager.sharedInstance.boardViewController = self.viewController;
        let scaleFactorX = Double(2048/(self.view?.frame.width)!);
        let scaleFactorY = Double(1536/(self.view?.frame.height)!);
        
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
            let posY = i.1.posY/scaleFactorY;
            let posX = i.1.posX/scaleFactorX;
            x.position.x = CGFloat(posX);
            x.position.y = CGFloat(posY);
            i.1.posX = posX;
            i.1.posY = posY;
            x.size = CGSize(width: CGFloat(35), height: CGFloat(35));
            self.addChild(x);
        }
        
        let x = (BoardGraph.SharedInstance.nodes["01"]?.posX)!;
        let y = (BoardGraph.SharedInstance.nodes["01"]?.posY)!;
        
        for p in GameManager.sharedInstance.players{
            let sprite = SKSpriteNode(texture: partsAtlas.textureNamed("pin"))
            p.x = x;
            p.y = y;
            sprite.zPosition = 100;
            sprite.position = CGPoint(x: x, y: y);
            sprite.colorBlendFactor = 0.9;
            sprite.color = p.color;
            sprite.size = CGSize(width: 15, height: 20);
            p.nodeSprite = sprite;
            BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(p)
            
            self.addChild(p.nodeSprite!)
        }
        
//        realPlayer = Player();
//        let sprite = SKShapeNode(circleOfRadius: 10.0);
//        realPlayer!.x = x;
//        realPlayer!.y = y;
//        print(realPlayer!.x, realPlayer!.y);
//        sprite.zPosition = 100;
//        sprite.position.x = CGFloat(realPlayer!.x);
//        sprite.position.y = CGFloat(realPlayer!.y);
//        sprite.fillColor = UIColor.blueColor();
//        realPlayer!.nodeSprite = sprite;
//        BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(realPlayer!)
//        
//        self.addChild(realPlayer!.nodeSprite!)

        GameManager.sharedInstance.playerTurnEnded(nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//          BoardGraph.SharedInstance.walk(1, player: realPlayer!, view: self.viewController)
//        realPlayer?.nodeSprite?.position = CGPoint(x: realPlayer!.x, y: realPlayer!.y);
           //GameManager.sharedInstance.beginMinigame()
        
    }
    
    
    override func didFinishUpdate() {
        super.didFinishUpdate();
        for p in GameManager.sharedInstance.players{
            p.nodeSprite?.position.x = CGFloat(p.x);
            p.nodeSprite?.position.y = CGFloat(p.y);
        }
    }
}