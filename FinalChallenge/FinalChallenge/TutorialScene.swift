//
//  tutorialScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 21/09/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene : MinigameScene, SKPhysicsContactDelegate {

    var spriteArray : [SKSpriteNode] = [SKSpriteNode]()
    var startButton : SKLabelNode!
    var goButton : SKSpriteNode!
    var background : SKSpriteNode!
    var fontSize : CGFloat = 26.0
    var nameText : SKLabelNode!
    var barName : SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        setObjects()
        
    }
    
    func setObjects(){
        //let valor = gameNumber!
        
        self.backgroundColor = UIColor.purpleColor()
        
        switch self.gameName {
            
            case "FlappyFish" :  setFlappyFish();
            
            case "BombGame" :  setBombBots();
            
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
        
        goButton = SKSpriteNode(imageNamed: "greenButtonOn")
        goButton.position = CGPoint(x: self.frame.width/1.2, y: self.frame.height/6)
        goButton.name = "StartGame"
        goButton.zPosition = 1001
        self.addChild(goButton)
        
        background = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: self.frame.width, height: self.frame.height/2))
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.width/10)
        background.zPosition = 1000
        background.alpha = 0.9
        self.addChild(background)
        
        barName = SKSpriteNode(imageNamed: "setUpBanner")
        barName.size.height = barName.size.height/3
        barName.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2.7)
        barName.zPosition = 1100
        
        nameText = SKLabelNode(fontNamed: "GillSans-Bold")
        nameText.text = "Flappy Fish"
        nameText.position.y = nameText.position.y - 10
        nameText.zPosition = 1101
        
        barName.addChild(nameText)
        self.addChild(barName)
        
        let d = SKNode()
        if !GameManager.sharedInstance.isMultiplayer{
            let desc = SKLabelNode(fontNamed: "GillSans-Bold")
            desc.text = "Avoid the rocks while swimming through the river."
            desc.position = CGPointMake(desc.position.x, desc.position.y)
            desc.fontColor = UIColor.blackColor()
            desc.fontSize = fontSize
            d.addChild(desc)
        
            let desc2 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc2.text = "Grab bubbles to gain a little boost. Press on "
            desc2.position = CGPointMake(desc2.position.x, desc2.position.y - 30)
            desc2.fontColor = UIColor.blackColor()
            desc2.fontSize = fontSize
            d.addChild(desc2)
        
            let desc3 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc3.text = "the upper part of the screen to swim up and the "
            desc3.position = CGPointMake(desc3.position.x, desc3.position.y - 60)
            desc3.fontColor = UIColor.blackColor()
            desc3.fontSize = fontSize
            d.addChild(desc3)
        
            let desc4 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc4.text = "botton to swim down"
            desc4.position = CGPointMake(desc4.position.x, desc4.position.y - 90)
            desc4.fontColor = UIColor.blackColor()
            desc4.fontSize = fontSize
            d.addChild(desc4)
        } else {
            let desc = SKLabelNode(fontNamed: "GillSans-Bold")
            desc.text = "Avoid the rocks while swimming through the river."
            desc.position = CGPointMake(desc.position.x, desc.position.y)
            desc.fontColor = UIColor.blackColor()
            desc.fontSize = fontSize
            d.addChild(desc)
            
            let desc2 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc2.text = "Grab bubbles to gain a little boost. Check your"
            desc2.position = CGPointMake(desc2.position.x, desc2.position.y - 30)
            desc2.fontColor = UIColor.blackColor()
            desc2.fontSize = fontSize
            d.addChild(desc2)
            
            let desc3 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc3.text = "device to check the game controls."
            desc3.position = CGPointMake(desc3.position.x, desc3.position.y - 60)
            desc3.fontColor = UIColor.blackColor()
            desc3.fontSize = fontSize
            d.addChild(desc3)
        }
        d.zPosition = 1002
        d.position = CGPoint(x: self.frame.width/3+5, y: self.frame.height/4)
        
        self.addChild(d)
        
        
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
        
        goButton = SKSpriteNode(imageNamed: "greenButtonOn")
        goButton.position = CGPoint(x: self.frame.width/1.2, y: self.frame.height/6)
        goButton.name = "StartGame"
        goButton.zPosition = 1001
        self.addChild(goButton)
        
        background = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: self.frame.width, height: self.frame.height/2))
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.width/10)
        background.zPosition = 1000
        background.alpha = 0.9
        self.addChild(background)
        
        barName = SKSpriteNode(imageNamed: "setUpBanner")
        barName.size.height = barName.size.height/3
        barName.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2.7)
        barName.zPosition = 1100
        
        nameText = SKLabelNode(fontNamed: "GillSans-Bold")
        nameText.text = "Bomb Game"
        nameText.position.y = nameText.position.y - 10
        nameText.zPosition = 1101
        
        barName.addChild(nameText)
        self.addChild(barName)
        
        let d = SKNode()
        if !GameManager.sharedInstance.isMultiplayer{
            let desc = SKLabelNode(fontNamed: "GillSans-Bold")
            desc.text = "Throw the bomb to other robots and don't let it "
            desc.position = CGPointMake(desc.position.x, desc.position.y)
            desc.fontColor = UIColor.blackColor()
            desc.fontSize = fontSize
            d.addChild(desc)
            
            let desc2 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc2.text = "explode on your hands! While traveling or left "
            desc2.position = CGPointMake(desc2.position.x, desc2.position.y - 30)
            desc2.fontColor = UIColor.blackColor()
            desc2.fontSize = fontSize
            d.addChild(desc2)
            
            let desc3 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc3.text = "unchecked, the bomb timer will go down until "
            desc3.position = CGPointMake(desc3.position.x, desc3.position.y - 60)
            desc3.fontColor = UIColor.blackColor()
            desc3.fontSize = fontSize
            d.addChild(desc3)
            
            let desc4 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc4.text = "some bot grab it again."
            desc4.position = CGPointMake(desc4.position.x, desc4.position.y - 90)
            desc4.fontColor = UIColor.blackColor()
            desc4.fontSize = fontSize
            d.addChild(desc4)
            
            let desc5 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc5.text = "While handling the bomb, swipe to throw "
            desc5.position = CGPointMake(desc5.position.x, desc5.position.y - 120)
            desc5.fontColor = UIColor.blackColor()
            desc5.fontSize = fontSize
            d.addChild(desc5)
            
            let desc6 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc6.text = "to the desired angle."
            desc6.position = CGPointMake(desc6.position.x, desc6.position.y - 150)
            desc6.fontColor = UIColor.blackColor()
            desc6.fontSize = fontSize
            d.addChild(desc6)

        } else {//"Throw the bomb to other robots and don't let it explode on your hands! While traveling or left unchecked, the bomb timer will go down until some bot grab it. Check your device to check the game controls"
            let desc = SKLabelNode(fontNamed: "GillSans-Bold")
            desc.text = "Throw the bomb to other robots and don't let it "
            desc.position = CGPointMake(desc.position.x, desc.position.y)
            desc.fontColor = UIColor.blackColor()
            desc.fontSize = fontSize
            d.addChild(desc)
            
            let desc2 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc2.text = "explode on your hands! While traveling or left "
            desc2.position = CGPointMake(desc2.position.x, desc2.position.y - 30)
            desc2.fontColor = UIColor.blackColor()
            desc2.fontSize = fontSize
            d.addChild(desc2)
            
            let desc3 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc3.text = "unchecked, the bomb timer will go down until "
            desc3.position = CGPointMake(desc3.position.x, desc3.position.y - 60)
            desc3.fontColor = UIColor.blackColor()
            desc3.fontSize = fontSize
            d.addChild(desc3)
            
            let desc4 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc4.text = "some bot grab it again. Check your"
            desc4.position = CGPointMake(desc4.position.x, desc4.position.y - 90)
            desc4.fontColor = UIColor.blackColor()
            desc4.fontSize = fontSize
            d.addChild(desc4)
            
            let desc5 = SKLabelNode(fontNamed: "GillSans-Bold")
            desc5.text = "device to check the game controls."
            desc5.position = CGPointMake(desc5.position.x, desc5.position.y - 120)
            desc5.fontColor = UIColor.blackColor()
            desc5.fontSize = fontSize
            d.addChild(desc5)
        }
        d.zPosition = 1002
        d.position = CGPoint(x: self.frame.width/3+5, y: self.frame.height/4)
        
        self.addChild(d)
    }
    //this func cleans whats inside tutorial scene and star another one
    func startGame(minigameName:String){
        self.removeAllChildren()
        self.removeAllActions()
        _ = SKTransition.flipHorizontalWithDuration(0.5)
        var goScene = MinigameScene()
        self.gameController?.dismissScene()
        switch(minigameName){
            case "FlappyFish": goScene = FlappyGameScene(size: self.size)
                               gameController?.scene = goScene
            case "BombGame":   goScene = BombTGameScene(size: self.size)
                               gameController?.scene = goScene
        default: break
        }
        self.view?.presentScene(goScene)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
        // working with bad go button
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if goButton.containsPoint(location){
                //change button go sprite
                goButton.texture = SKTexture(imageNamed: "greenButtonOff")
            }
        }
        
        // runs throught sprites looking to show ther text i think...
        for sprite in spriteArray {
            if (sprite.containsPoint(location)){
                //print("achei um cara")
              
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // working with bad go button
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            if goButton.containsPoint(location){
                goButton.texture = SKTexture(imageNamed: "greenButtonOff")
                //print("Iniciou jogo")
                switch(self.gameName){
                case "FlappyFish": startGame(self.gameName)//start scene
                case "BombGame": startGame(self.gameName)
                default: break
                }
            }
        }
    }
    
    deinit{
        //print("Tutorial scene is out of the memory")
    }
}