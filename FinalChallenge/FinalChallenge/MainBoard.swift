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
                    
                    // add gold se existir no mapa
                    if (i.1.coins > 0){
                        
                        
                        let goldCoins = SKSpriteNode(texture: self.partsAtlas.textureNamed("gold"))
                        self.addChild(goldCoins)
                        goldCoins.position = CGPoint(x: i.1.posX, y: i.1.posY)
                        goldCoins.zPosition = 20
                    }
                    
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
                    p.nodeSprite?.zPosition = 100
                    self.addChild(p.nodeSprite!)
                }
                
                tutorialNodes["Player"] = GameManager.sharedInstance.players.first?.nodeSprite
                
                if !GlobalFlags.boardTaught {
                    setTutorial()
                }
            
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
                    
                    
                    // add gold se existir no mapa
                    if (i.1.coins > 0){
                        
                        
                        let goldCoins = SKSpriteNode(texture: self.partsAtlas.textureNamed("gold"))
                        self.addChild(goldCoins)
                        goldCoins.position = CGPoint(x: i.1.posX, y: i.1.posY)
                        goldCoins.zPosition = 20
                    }
                    
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
    
    func showDiceNumber(number:Int, player: PlayerNode, extraDice : Bool) {
        let diceAtlas = SKTextureAtlas(named: "dices")
        var position = player.position
        position.y += player.frame.height
        if !extraDice{
            if number <= 6 {
                let node = SKSpriteNode(texture:    diceAtlas.textureNamed("dice\(number)"))
                node.position = position
                node.zPosition = 400
                addChild(node)
                node.setScale(0.5)
                let action = SKAction.scaleTo(1.0, duration: 1.0)
                node.runAction(action, completion: {() in
                    node.removeFromParent()
                })
            }
        } else {
            switch(number){
            case 2:
                    setNumberShow(1, s: 1, player: player)
            case 3: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(2))){
                    case 0:
                        f = 2
                        s = 1
                    case 1:
                        f = 1
                        s = 2
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 4: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(3))){
                    case 0:
                        f = 2
                        s = 1
                    case 1:
                        f = 1
                        s = 3
                    case 2:
                        f = 3
                        s = 1
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 5: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(4))){
                    case 0:
                        f = 3
                        s = 2
                    case 1:
                        f = 2
                        s = 3
                    case 2:
                        f = 1
                        s = 4
                    case 3:
                        f = 4
                        s = 1
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 6: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(5))){
                    case 0:
                        f = 3
                        s = 3
                    case 1:
                        f = 2
                        s = 4
                    case 2:
                        f = 4
                        s = 2
                    case 3:
                        f = 5
                        s = 1
                    case 4:
                        f = 1
                        s = 5
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 7: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(6))){
                    case 0:
                        f = 1
                        s = 6
                    case 1:
                        f = 6
                        s = 1
                    case 2:
                        f = 5
                        s = 2
                    case 3:
                        f = 2
                        s = 5
                    case 4:
                        f = 4
                        s = 3
                    case 5:
                        f = 3
                        s = 4
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 8: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(5))){
                    case 0:
                        f = 4
                        s = 4
                    case 1:
                        f = 6
                        s = 2
                    case 2:
                        f = 2
                        s = 6
                    case 3:
                        f = 5
                        s = 3
                    case 4:
                        f = 3
                        s = 5
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 9: var f = 0
                    var s = 0
                    switch(Int(arc4random_uniform(4))){
                    case 0:
                        f = 5
                        s = 4
                    case 1:
                        f = 4
                        s = 5
                    case 2:
                        f = 3
                        s = 6
                    case 3:
                        f = 6
                        s = 3
                    default : break
                    }
                    setNumberShow(f, s: s, player: player)
            case 10: var f = 0
                     var s = 0
                     switch(Int(arc4random_uniform(3))){
                     case 0:
                         f = 5
                         s = 5
                     case 1:
                         f = 4
                         s = 6
                     case 2:
                         f = 6
                         s = 4
                     default : break
                     }
                     setNumberShow(f, s: s, player: player)
            case 11: var f = 0
                     var s = 0
                     switch(Int(arc4random_uniform(2))){
                     case 0:
                         f = 6
                         s = 5
                     case 1:
                         f = 5
                         s = 6
                     default : break
                     }
                    setNumberShow(f, s: s, player: player)
            case 12:
                    setNumberShow(6, s: 6, player: player)
            default : break
            }
        }
    }
    
    func setNumberShow(f:Int, s:Int, player : PlayerNode){
        let diceAtlas = SKTextureAtlas(named: "dices")
        var position = player.position
        position.y += player.frame.height
        let node = SKSpriteNode(texture: diceAtlas.textureNamed("dice\(f)"))
        let node2 = SKSpriteNode(texture: diceAtlas.textureNamed("dice\(s)"))
        node.position = position
        node.zPosition = 400
        node.position.x = node.position.x - node.frame.size.width/2
        node2.position = position
        node2.position.x = node2.position.x + node2.frame.size.width/2
        node2.zPosition = 400
        addChild(node)
        addChild(node2)
        node.setScale(0.5)
        node2.setScale(0.5)
        let action = SKAction.scaleTo(1.0, duration: 1.0)
        node.runAction(action, completion: {() in
            node.removeFromParent()
        })
        node2.runAction(action, completion: {() in
            node2.removeFromParent()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        showCard((GameManager.sharedInstance.players.first?.nodeSprite)!, good: true)
        animatePlayerOnTrap(GameManager.sharedInstance.players.first!.nodeSprite!)
    }
    
    func animatePlayerOnTrap(player: PlayerNode) {
        let moveRight = SKAction.moveToX(player.position.x + 5, duration: 0.1)
        let moveLeft = SKAction.moveToX(player.position.x - 5, duration: 0.1)
        let sequence = SKAction.sequence([moveRight,moveLeft])
        let repeatAction = SKAction.repeatAction(sequence, count: 5)
        let restart = SKAction.moveToX(player.position.x, duration: 0.0)
        let finalSequence = SKAction.sequence([repeatAction,restart])
        player.runAction(finalSequence)
    }
    
    deinit{
        print("A main board saiu")
    }
    
    func setTutorial() {
        let strings = TutorialManager.loadStringsPlist("board")
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        tuples.append((nil,strings[0],nil))
        tuples.append((nil,strings[1],nil))
        tuples.append((tutorialNodes["Player"],strings[2],nil))
        tuples.append((tutorialNodes["Store"],strings[3],nil))
        tuples.append((tutorialNodes["House"],strings[4],nil))
        tuples.append((tutorialNodes["Bau1"],strings[5],nil))
        
        
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: false, boxScale: 1.0)
        tutorialManager.showInfo()
        GlobalFlags.boardTaught = true
    }
}