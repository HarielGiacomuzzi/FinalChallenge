//
//  GameOverSceneMP.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/10/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class GameOverSceneMP : MinigameScene {
    
    var players:[String] = []
    var playerNode:[SKSpriteNode] = []
    var playerArray = [Player?](count: 3, repeatedValue: nil )
    
    var player1 : Player?
    var player2 : Player?
    var player3 : Player?
    
    override func didMoveToView(view: SKView) {
        /*
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.name = "bg"
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        
        let back = SKLabelNode(fontNamed: "GillSans-Bold")
        back.text = "Back to Board"
        back.name = "Back to Board"
        back.position = CGPointMake(self.size.width/2, 50)
        self.addChild(back) */
        
        //precisa estar do maior pro menor
        for i in 0..<players.count{
            
            var p = Player()
            
            for j in GameManager.sharedInstance.players{
                if players[i] == j.playerIdentifier{
                    p = j
                }
            }
            /*
            let sprite =  SKSpriteNode(imageNamed: p.avatar!)
            
            sprite.name = p.avatar!
            
            sprite.size = CGSize(width: 100, height: 200)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(players.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            
            self.addChild(sprite)*/
            
            print("dando o dinheiro para o player \(p.playerIdentifier)")
            print("playerCount =  \(players.count)")
            
            if i < players.count-1 { //not last player
                switch i {
                case 0:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 50)
                    player1 = p
                    print("dando 50 para o player \(p.playerIdentifier)")
                case 1:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 25)
                    player2 = p
                    print("dando 25 para o player \(p.playerIdentifier)")
                case 2:
                    GameManager.sharedInstance.updatePlayerMoney(p, value: 5)
                    print("dando 5 para o player \(p.playerIdentifier)")
                    player3 = p
                    
                default:
                    ()
                }
            }
        }
        
        // SETUP DA TELA
        self.backgroundColor = UIColor.whiteColor()
        let banner = SKSpriteNode(imageNamed: "setUpBanner")
        self.addChild(banner)
        banner.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        banner.size.height = banner.size.height
        banner.zPosition = 8
        banner.name = "banner"
        
        let titleLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        titleLabel.text = "Mini Game Results"
        titleLabel.name = "label"
        titleLabel.zPosition = 9
        titleLabel.fontSize = titleLabel.fontSize * 1.7
        titleLabel.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        self.addChild(titleLabel)
        
        
        thirdPlace(player3)
        
        
    }
    
    //touch nodes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch : UITouch? = touches.first as UITouch?
        
        if let location = touch?.locationInNode(self) {
            let touchedNode = self.nodeAtPoint(location)
            
            _ = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
            self.view?.presentScene(nil)
            GameManager.sharedInstance.dismissMinigameMP()

        }
    }
    
    
    func secondPlace(secondPlayer : Player?){
        
        
        let base : SKSpriteNode = SKSpriteNode(imageNamed: "squarebackground")
        base.name = "fundo tela Segundo MENOR LOSER"
        
        base.colorBlendFactor = 0.7
        base.size = CGSize(width: base.frame.width, height: self.frame.height)
        
        let posicaoFinal = CGPoint(x: base.frame.width/2 , y: self.frame.height/2)
        base.position = CGPoint(x: -(base.frame.width/2), y: self.frame.height/2)
        
        self.addChild(base)
        
        if let player = secondPlayer {
            base.color = player.color
            let avatar : SKSpriteNode = SKSpriteNode(imageNamed: player.avatar!)
            avatar.position = CGPoint(x: -70, y: -170)
            base.addChild(avatar)
            avatar.zPosition = 2
            avatar.size = CGSize(width: avatar.size.width * 0.7, height: avatar.size.height * 0.7)
        }
        
        
        let movement = SKAction.moveTo(posicaoFinal, duration: 0.5)
        base.runAction(movement){ () -> Void in
            self.firstPlace(self.player1)
        }
        
        
        
    }
    
    func thirdPlace(thirdPlayer : Player?){
        
        
        let base : SKSpriteNode = SKSpriteNode(imageNamed: "squarebackground")
        base.name = "fundo tela Segundo MAIOR LOSER"
        
        base.colorBlendFactor = 0.7
        base.size = CGSize(width: base.frame.width, height: self.frame.height)
        let posicaoFinal = CGPoint(x: self.frame.width - base.frame.width/2, y: self.frame.height/2)
        base.position = CGPoint(x: self.frame.width + base.frame.width/2, y: self.frame.height/2)
        
        self.addChild(base)
        
        if let player = thirdPlayer {
            base.color = player.color
            let avatar : SKSpriteNode = SKSpriteNode(imageNamed: player.avatar!)
            avatar.position = CGPoint(x: -70, y: -170)
            base.addChild(avatar)
            avatar.zPosition = 2
            avatar.size = CGSize(width: avatar.size.width * 0.7, height: avatar.size.height * 0.7)
        }
        
        
        let movement = SKAction.moveTo(posicaoFinal, duration: 0.5)
        base.runAction(movement) { () -> Void in
            self.secondPlace(self.player2)
        }
        
    }
    
    func firstPlace(firstPlayer : Player?){
        
        
        let base : SKSpriteNode = SKSpriteNode(imageNamed: "winnerbackground")
        base.name = "fundo tela Segundo MAIOR LOSER"
        
        base.colorBlendFactor = 0.7
        base.zPosition = 3
        
        let posicaoFinal = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        base.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + base.frame.height)
        base.zPosition = 3
        self.addChild(base)
        
        if let player = firstPlayer {
            base.color = player.color
            let avatar : SKSpriteNode = SKSpriteNode(imageNamed: player.avatar!)
            avatar.position = CGPoint(x: -70, y: -170)
            base.addChild(avatar)
            avatar.zPosition = 2
            avatar.size = CGSize(width: avatar.size.width * 0.7, height: avatar.size.height * 0.7)
        }
        
        let movement = SKAction.moveTo(posicaoFinal, duration: 0.5)
        base.runAction(movement) {
            () -> Void in
            self.riseGold()
        }
        
    }
    
    
    func riseGold(){
        
        let first = SKLabelNode(fontNamed: "GillSans-Bold")
        first.text = "+50 gold"
        first.position = CGPoint(x: self.frame.width/2, y: self.frame.height * 0.05)
        first.zPosition = 9
        first.fontSize = first.fontSize * 1.25
        first.fontColor = UIColor.yellowColor()
        self.addChild(first)
        
        let movement = SKAction.moveToY(self.frame.height * 0.35, duration: 1.5 )
        let grow = SKAction.scaleBy(1.2, duration: 0.95)
        let fading = SKAction.fadeOutWithDuration(0.9)
        //   let group = SKAction.group([movement, fading])
        //  let wait = SKAction.waitForDuration(0.1)
        let appear = SKAction.fadeInWithDuration(1.2)
        let coinGroup = SKAction.group([appear])
        let fadeGroup = SKAction.group([grow, fading])
        
        first.runAction(movement) { () -> Void in
            let firstNode = SKSpriteNode(imageNamed: "firstPlace")
            firstNode.position = CGPoint(x: first.position.x , y: self.frame.height * 0.15)
            self.addChild(firstNode)
            firstNode.zPosition = 9
            firstNode.alpha = 0
            firstNode.runAction(appear)
            
            
            weak var coinParticle = EndGameParticleNode.fromFile("coinParticle")
            coinParticle?.position = CGPointMake(first.position.x, first.position.y)
            //  coinParticle!.targetNode = self.scene
            self.addChild(coinParticle!)
            coinParticle?.zPosition = 11
            coinParticle?.runAction(coinGroup, completion: { () -> Void in
                coinParticle?.runAction(fading, completion: { () -> Void in
                    coinParticle?.removeFromParent()
                })
                
            })
            
            first.runAction(fadeGroup, completion: { () -> Void in
                first.removeFromParent()
            })
            
            
            let second = SKLabelNode(fontNamed: "GillSans-Bold")
            second.text = "+20 gold"
            second.position = CGPoint(x: self.frame.width * 0.2, y: self.frame.height * 0.05)
            second.zPosition = 5
            second.fontSize = second.fontSize * 1.25
            second.fontColor = UIColor.yellowColor()
            self.addChild(second)
            second.runAction(movement) { () -> Void in
                
                
                let secondNode = SKSpriteNode(imageNamed: "secondPlace")
                secondNode.position = CGPoint(x: second.position.x , y: self.frame.height * 0.128)
                self.addChild(secondNode)
                secondNode.size = CGSize(width: secondNode.frame.width * 0.9, height: secondNode.frame.height * 0.9)
                secondNode.zPosition = 9
                secondNode.alpha = 0
                secondNode.runAction(appear)
                
                
                
                weak var coinParticle2 = EndGameParticleNode.fromFile("coinParticle")
                coinParticle2?.position = CGPointMake(second.position.x, second.position.y)
                //  coinParticle!.targetNode = self.scene
                self.addChild(coinParticle2!)
                coinParticle2?.zPosition = 11
                coinParticle2?.runAction(coinGroup, completion: { () -> Void in
                    coinParticle2?.runAction(fading, completion: { () -> Void in
                        coinParticle2?.removeFromParent()
                    })
                    
                })
                
                second.runAction(fadeGroup, completion: { () -> Void in
                    second.removeFromParent()
                })
                
                
                
                let third = SKLabelNode(fontNamed: "GillSans-Bold")
                third.text = "+5 gold"
                third.position = CGPoint(x: self.frame.width * 0.8, y: self.frame.height * 0.05)
                third.zPosition = 5
                third.fontSize = third.fontSize * 1.25
                third.fontColor = UIColor.yellowColor()
                self.addChild(third)
                third.runAction(movement) { () -> Void in
                    let thirdNode = SKSpriteNode(imageNamed: "thirdPlace")
                    thirdNode.position = CGPoint(x: third.position.x , y: self.frame.height * 0.09)
                    self.addChild(thirdNode)
                    //     thirdNode.size = CGSize(width: thirdNode.frame.width * 0.85, height: thirdNode.frame.height * 0.85)
                    thirdNode.zPosition = 9
                    thirdNode.alpha = 0
                    thirdNode.runAction(appear)
                    
                    weak var coinParticle3 = EndGameParticleNode.fromFile("coinParticle")
                    coinParticle3?.position = CGPointMake(third.position.x, third.position.y)
                    //  coinParticle!.targetNode = self.scene
                    self.addChild(coinParticle3!)
                    coinParticle3?.zPosition = 11
                    coinParticle3?.runAction(coinGroup, completion: { () -> Void in
                        coinParticle3?.runAction(fading, completion: { () -> Void in
                            coinParticle3?.removeFromParent()
                        })
                        
                    })
                    
                    third.runAction(fadeGroup, completion: { () -> Void in
                        third.removeFromParent()
                    })                }
            }
        }
        
        
        
        
    }
    
    
    
    
}
