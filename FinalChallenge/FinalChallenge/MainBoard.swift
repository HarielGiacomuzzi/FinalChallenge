//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    weak var viewController: UIViewController?
    var realPlayer : Player?
    let partsAtlas = SKTextureAtlas(named: "Board")

    override func update(currentTime: NSTimeInterval) {
        if !self.paused && GameManager.sharedInstance.gameEnded{
            self.presentEndGameScene()
            self.paused = true
        }
    }

    override func didMoveToView(view: SKView) {
            GameManager.sharedInstance.boardViewController = self.viewController;
            GameManager.sharedInstance.isOnBoard = true;
            let scaleFactorX = Double(2048/(self.view?.frame.width)!);
            let scaleFactorY = Double(1536/(self.view?.frame.height)!);
            if !GameManager.sharedInstance.doOnce{
                
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square1");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("house");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("shop");
                    }
                    
                    if i.1.nextMoves.count > 1 {
                        texture = self.partsAtlas.textureNamed("square2");
                    }
                    
                    let x = SKSpriteNode(texture: texture)
                        let posY = i.1.posY/scaleFactorY;
                        let posX = i.1.posX/scaleFactorX;
                    
                        x.position.x = CGFloat(posX);
                        x.position.y = CGFloat(posY);
                        x.zPosition = 10
                        i.1.posX = posX;
                        i.1.posY = posY;
                        x.size = CGSize(width: CGFloat(35), height: CGFloat(35));
                    
                    self.addChild(x);
                    
                    GameManager.sharedInstance.doOnce = true
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
                
                
                GameManager.sharedInstance.playerTurnEnded(nil)
            }else{
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square1");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("house");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("shop");
                    }
                    
                    if i.1.nextMoves.count > 1 {
                        texture = self.partsAtlas.textureNamed("square2");
                    }
                    
                    let x = SKSpriteNode(texture: texture)
                    
                    x.position.x = CGFloat(i.1.posX);
                    x.position.y = CGFloat(i.1.posY);
                    x.size = CGSize(width: CGFloat(35), height: CGFloat(35));
                    
                    self.addChild(x);
                }
                
                for p in GameManager.sharedInstance.players{
                    self.addChild(p.nodeSprite!)
                }
                
            }
    }

    func presentEndGameScene(){
        print("Apresentou EndGame")
        self.removeAllChildren()
        self.removeAllActions()
        _ = SKTransition.flipHorizontalWithDuration(0.5)
        let goScene = EndGameScene(size: self.size)
        goScene.scaleMode = .AspectFit
        self.view?.presentScene(goScene)

    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate();
        for p in GameManager.sharedInstance.players{
            p.nodeSprite?.position.x = CGFloat(p.x);
            p.nodeSprite?.position.y = CGFloat(p.y);
        }
    }
    
    deinit{
        print("A main board saiu")
    }
}