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
    let map = SKSpriteNode(imageNamed: "map")
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
            setupMap()
            if !GameManager.sharedInstance.doOnce{
                
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("house");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("shop");
                    }
                    
                    if i.1.nextMoves.count > 1 {
                        texture = self.partsAtlas.textureNamed("square");
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
                    p.x = x;
                    p.y = y;
                    p.nodeSprite = PlayerNode(named: p.avatar!);
                    p.nodeSprite?.position = CGPointMake(CGFloat(p.x), CGFloat(p.y))
                    BoardGraph.SharedInstance.nodes["01"]?.currentPlayers.append(p)
                    p.nodeSprite?.setScale(0.5)
                    p.nodeSprite?.anchorPoint = CGPointMake(0.5, 0.25)
                    p.nodeSprite?.zPosition = 20
                    self.addChild(p.nodeSprite!)
                }
                
                
                GameManager.sharedInstance.playerTurnEnded(nil)
            }else{
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("house");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("shop");
                    }
                    
                    if i.1.nextMoves.count > 1 {
                        texture = self.partsAtlas.textureNamed("square");
                    }
                    
                    let x = SKSpriteNode(texture: texture)
                    
                    x.position.x = CGFloat(i.1.posX);
                    x.position.y = CGFloat(i.1.posY);
                    x.size = CGSize(width: CGFloat(35), height: CGFloat(35));
                    
                    x.zPosition = 10
                    self.addChild(x);
                }
                
                for p in GameManager.sharedInstance.players{
                    self.addChild(p.nodeSprite!)
                }
                
            }
    }

    func setupMap(){
        map.position.x = CGFloat((self.view?.frame.width)!/2);
        map.position.y = CGFloat((self.view?.frame.height)!/2);
        map.zPosition = 5
        self.addChild(map);
    }
    
    func presentEndGameScene(){
        //print("Apresentou EndGame")
        self.removeAllChildren()
        self.removeAllActions()
        _ = SKTransition.flipHorizontalWithDuration(0.5)
        let goScene = EndGameScene(size: self.size)
        goScene.scaleMode = self.scaleMode
        self.view?.presentScene(goScene)
    }
    

    
    deinit{
        //print("A main board saiu")
    }
}