//
//  tutorialScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 21/09/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class tutorialScene : SKScene, SKPhysicsContactDelegate {
    
    
    weak var viewController : MinigameDescriptionViewController!
    var gameName : NSString?
    var gameNumber : Int?
    var spriteArray : [SKSpriteNode] = [SKSpriteNode]()
    
    
    override func didMoveToView(view: SKView) {
        
        setObjects()

        
        
        
    }
    
    func setObjects(){
        let valor = gameNumber!
        
        switch valor {
        case 1 :  setFlappyFish();
            
        case 2 :  setBombBots();
            
        default : break;
            
            
            
            
        }
        
        
        
        
    }

    
    func setFlappyFish(){
        let fundo : SKSpriteNode = SKSpriteNode(imageNamed: "flappystatic")
        fundo.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(fundo)
        
        let myAtlas = SKTextureAtlas(named: "fish")//sprites
        let fishTexture = myAtlas.textureNamed("fish0")
        
        let fish : SKSpriteNode = SKSpriteNode(texture: fishTexture)
        fish.position = CGPoint(x: self.frame.width/2 - 250, y: self.frame.height/2 + 50)
        fish.zPosition = 10
        fish.name = "Playable character"
        self.addChild(fish)
        spriteArray.append(fish)
        
        let rockAtlas = SKTextureAtlas(named: "rock")//sprites
        let rockTexture = rockAtlas.textureNamed("bigrock1")
        let rock : SKSpriteNode = SKSpriteNode(texture: rockTexture)
        rock.position = CGPoint(x: self.frame.width/2 + 280, y: self.frame.height/2 + 100)
        rock.zPosition = 10
        rock.size = CGSize(width: rock.size.width * 1.5, height: rock.size.height * 1.5)
        rock.name = "Pulls you down the current"
        self.addChild(rock)
        spriteArray.append(rock)
        
        
        let bubbleAtlas = SKTextureAtlas(named: "bubble")
        let bubbleTexture = bubbleAtlas.textureNamed("bubble%200")
        let bubble : SKSpriteNode = SKSpriteNode(texture: bubbleTexture)
        bubble.zPosition = 10
        bubble.position = CGPoint(x: self.frame.width/2 - 80, y: self.frame.height/2 - 45)
        self.addChild(bubble)
        bubble.name = "Gives small burst"
        spriteArray.append(bubble)
        
    }
    
    func setBombBots(){
        
        let fundo = SKSpriteNode(imageNamed: "floor")
        self.addChild(fundo)
        fundo.position = CGPoint(x: self.frame.width / 2, y : self.frame.height/2)
        
        
        var size = CGSize(width: self.frame.size.height, height: 45)
        let north = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallh"))
        north.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 15)
        self.addChild(north)
        north.zPosition = 22
        
        
        //south wall
        size = CGSize(width: self.frame.size.height, height: 45)
        let south = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallh"))
        south.position = CGPointMake(self.frame.size.width / 2, 15)
        self.addChild(south)
        south.zPosition = 22

        
        //east wall
        size = CGSize(width: 45, height: self.frame.size.height)
        let blackBar = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: (self.frame.width - south.size.width), height: self.frame.height))
        blackBar.position = CGPoint(x: 0 , y: self.frame.height/2)
        blackBar.zPosition = 20
        
        self.addChild(blackBar)
        
        let east = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallv"))
        east.position = CGPointMake(north.position.x + north.size.width / 2, self.frame.size.height / 2)
        self.addChild(east)
        east.zPosition = 23

        
        //west wall
        
        
        let blackBar2 = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: (self.frame.width - south.size.width), height: self.frame.height))
        blackBar2.position = CGPoint(x: self.frame.width , y: self.frame.height/2)
        blackBar2.zPosition = 20
        
        self.addChild(blackBar2)
        
        size = CGSize(width: 45, height: self.frame.size.height)
        let west = BombWallNode(size: size, texture: SKTexture(imageNamed: "wallv"))
        west.position = CGPointMake(north.position.x - north.size.width / 2, self.frame.size.height / 2)
        self.addChild(west)
        west.zPosition = 23

        let robo : SKSpriteNode = SKSpriteNode(imageNamed: "roboTutorial")
        robo.zPosition = 10
        robo.position = CGPoint(x: self.frame.width/2 - 325, y: self.frame.height/2 )
        robo.zRotation = 3.14/2
        robo.name = "Playable Character"
        self.addChild(robo)
        spriteArray.append(robo)
        

        
        let x = self.frame.size.width/2
        let y = self.frame.size.height/2
        
        let spriteAnimatedAtlas = SKTextureAtlas(named: "bombGame")//sprites
        
        let texture = spriteAnimatedAtlas.textureNamed("bombModel")
        
        
        let bomb = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: CGSize(width: 50 , height: 50))
        bomb.position = CGPointMake(x - 150, y + 200)
        bomb.name = "Will explode in seconds"
        bomb.zPosition = 20
        bomb.zRotation = 3.15 * 0.65
        self.addChild(bomb)
        spriteArray.append(bomb)
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
        for sprite in spriteArray {
            if (sprite.containsPoint(location)){
                print("achei um cara")
              
                
                let spriteAnimatedAtlas = SKTextureAtlas(named: "popup")//sprites
                
                // inicializa corrida
                var runFrames = [SKTexture]()
                for var i=1; i<11; i++
                {
                    let runTextureName = "desc\(i)"
                    runFrames.append(spriteAnimatedAtlas.textureNamed(runTextureName))
                }
                
                
                let firstAction = SKAction.animateWithTextures(runFrames, timePerFrame: 0.05)
                
                
                let label : SKLabelNode = SKLabelNode(text: sprite.name)
                label.zPosition = 101
                label.position = CGPoint(x: sprite.position.x - 10  , y: sprite.position.y + 50)
                label.fontSize = 18
                label.fontName = "Gill Sans"
                
                
                let square : SKSpriteNode = SKSpriteNode(texture: runFrames[0])
                square.zPosition = 100
                square.position = CGPoint(x: label.position.x, y: label.position.y  + 5)
                self.addChild(square)
                square.runAction(firstAction, completion: { () -> Void in
                    self.addChild(label)
                })
                
                
            }
        }
 
        
        
    }
    

    
    
}