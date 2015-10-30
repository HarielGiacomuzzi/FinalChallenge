//
//  MainBoard.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/19/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class MainBoard: SKScene, SKPhysicsContactDelegate {
    
    var tutorialManager: TutorialManager!
    
    weak var viewController: UIViewController?
    var realPlayer : Player?
    let map = SKSpriteNode(imageNamed: "map")
    let partsAtlas = SKTextureAtlas(named: "Board")
    
    var tutorialNodes: [String: SKNode] = [:]

    override func update(currentTime: NSTimeInterval) {
        if !self.paused && GameManager.sharedInstance.gameEnded{
            self.presentEndGameScene()
            self.paused = true
        }
    }

    override func didMoveToView(view: SKView) {
            GameManager.sharedInstance.boardViewController = self.viewController;
            GameManager.sharedInstance.isOnBoard = true;
            AudioSource.sharedInstance.mainGameSound()
            let scaleFactorX = Double(2048/(self.view?.frame.width)!);
            let scaleFactorY = Double(1536/(self.view?.frame.height)!);
            setupMap()
            if !GameManager.sharedInstance.doOnce{
                
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("square");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("square");
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
                    
                    //arrumar a posicao quando tiver os quadradinhos no lugar certo ja
                    if i.0 == "Bau1" || i.0 == "Bau2" {
                        let chest = SKSpriteNode(imageNamed: "chest0")
                        chest.position = CGPointMake(CGFloat(i.1.posX), CGFloat(i.1.posY))
                        chest.position.y = chest.position.y + x.frame.height + ((chest.frame.size.height/2)/CGFloat(scaleFactorY))
                        print(chest.position)
                        chest.zPosition = 17
                        addChild(chest)
                    }
                    
                    self.addChild(x);
                
                    if i.0 == "House" || i.0 == "Store" || i.0 == "Bau1" {
                        tutorialNodes[i.0] = x
                    }
                    
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
                
                tutorialNodes["Player"] = GameManager.sharedInstance.players.first?.nodeSprite
                
                setTutorial()
            
                GameManager.sharedInstance.playerTurnEnded(nil)
            }else{
                for i in BoardGraph.SharedInstance.nodes{
                    var texture = self.partsAtlas.textureNamed("square");
                    if i.0 == "House"{
                        texture = self.partsAtlas.textureNamed("square");
                    }
                    if i.0 == "Store" {
                        texture = self.partsAtlas.textureNamed("square");
                    }
                    
                    if i.1.nextMoves.count > 1 {
                        texture = self.partsAtlas.textureNamed("square");
                    }
                    
                    let x = SKSpriteNode(texture: texture)
                    
                    x.position.x = CGFloat(i.1.posX);
                    x.position.y = CGFloat(i.1.posY);
                    x.size = CGSize(width: CGFloat(35), height: CGFloat(35));
                    
                    //arrumar a posicao quando tiver os quadradinhos no lugar certo ja
                    if i.0 == "Bau1" || i.0 == "Bau2" {
                        let chest = SKSpriteNode(imageNamed: "chest0")
                        chest.position = CGPointMake(CGFloat(i.1.posX), CGFloat(i.1.posY))
                        chest.position.y = chest.position.y + x.frame.height + ((chest.frame.size.height/2)/CGFloat(scaleFactorY))
                        print(chest.position)
                        chest.zPosition = 17
                        addChild(chest)
                    }
                    
                    //add trap to board
                    if let item = i.1.item {
                        if item.usable {
                            let usable = item as! ActiveCard
                            if usable.used {
                                addTrap(CGFloat(i.1.posX), y: CGFloat(i.1.posY))
                            }
                        }
                    }
                    
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
    
    func addTrap(x:CGFloat, y:CGFloat) {
        let trap = SKSpriteNode(imageNamed: "trap")
        trap.position = CGPointMake(x, y)
        trap.name = "trap"
        trap.zPosition = 15
        addChild(trap)
        
    }
    
    func removeTrap(x:CGFloat, y:CGFloat) {
        let nodes = nodesAtPoint(CGPointMake(x, y))
        for node in nodes {
            if node.name == "trap" {
                node.removeFromParent()
            }
        }
    }
    
    func showDiceNumber(number:Int, player: PlayerNode) {
        var position = player.position
        position.y += player.frame.height/2
        let label = SKLabelNode(text: "\(number)")
        label.position = position
        label.zPosition = 400
        label.fontName = "GillSans-Bold"
        addChild(label)
        let action = SKAction.scaleTo(2.0, duration: 1.0)
        label.runAction(action, completion: {() in
            label.removeFromParent()
        })
    }
    
    func showMoney(player:PlayerNode, good:Bool) {
        var position = player.position
        position.y += player.frame.height
        let coinNode = SKSpriteNode(imageNamed: "coinparticle")
        coinNode.setScale(0.5)
        coinNode.position = position
        coinNode.zPosition = 400
        if !good {
            coinNode.color = UIColor.redColor()
            coinNode.colorBlendFactor = 0.4
        }
        addChild(coinNode)
        let action = SKAction.scaleTo(1.0, duration: 1.0)
        coinNode.runAction(action, completion: {() in
            coinNode.removeFromParent()
        })
    }
    
    func showCard(player:PlayerNode, good:Bool) {
        var position = player.position
        position.y += player.frame.height
        let cardNode = SKSpriteNode(imageNamed: "trapCardBase")
        cardNode.setScale(0.025)
        cardNode.position = position
        cardNode.zPosition = 400
        if !good {
            cardNode.color = UIColor.redColor()
            cardNode.colorBlendFactor = 0.4
        }
        addChild(cardNode)
        let action = SKAction.scaleTo(0.05, duration: 1.0)
        cardNode.runAction(action, completion: {() in
            cardNode.removeFromParent()
        })
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        showCard((GameManager.sharedInstance.players.first?.nodeSprite)!, good: true)
//    }
    
    deinit{
        print("A main board saiu")
    }
    
    func setTutorial() {
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        
        tuples.append((tutorialNodes["Player"],"Here is the player",nil))
        tuples.append((tutorialNodes["House"],"Here is the house",nil))
        tuples.append((tutorialNodes["Store"],"Here is the store",nil))
        tuples.append((tutorialNodes["Bau1"],"Here is the chest",nil))
        
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: false, boxScale: 1.0)
        tutorialManager.showInfo()
    }
}