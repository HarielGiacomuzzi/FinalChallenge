//
//  SwipeScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/1/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

// robotto game
class SwipeScene: GamePadScene {
    
    var beginX:CGFloat = 0.0
    var beginY:CGFloat = 0.0
    var button : SKSpriteNode?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInView(self.view)
        beginX = location.x
        beginY = location.y
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInView(self.view)
        let endX = location.x
        let endY = location.y
        let x = endX - beginX
        let y = (endY - beginY) * -1
        
        var vector = CGVectorMake(x, y)
        
        vector.normalize()
        
        sendVector(vector.dx, y: vector.dy)
    }
    
    func sendVector(x:CGFloat, y:CGFloat) {
        let action = ["x":x, "y":y]
        let dic = ["controllerAction":"", "action":action]
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let label = SKLabelNode(text: "SWIPE")
        label.fontSize = 70
        label.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(label)
        setObjects()
        
    }
    
    func setObjects(){
        let background = SKSpriteNode(imageNamed: "roboControlerBase")
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.addChild(background)
        background.zPosition = 1
        
        let playerBar = SKSpriteNode(imageNamed: "robotColorReference")
        playerBar.color = UIColor.purpleColor()
        playerBar.colorBlendFactor = 0.6
        playerBar.position = CGPoint(x: self.frame.width * 0.14, y: self.frame.height/2 + 150)
        self.addChild(playerBar) // alterar para cor do player
        playerBar.size = CGSize(width: self.frame.width * 0.13, height: self.frame.height * 0.75)
        playerBar.zPosition = 2
        
        
        button = SKSpriteNode(imageNamed: "roboGreenButton")
        button!.position = CGPoint(x: playerBar.position.x - 22, y: self.frame.height * 0.2)
        self.addChild(button!)
        button!.zPosition = 2
        button?.size = CGSize(width: playerBar.size.width, height: playerBar.size.width)
        
        let visor = SKSpriteNode(imageNamed: "roboRadar")
        visor.position = CGPoint(x: self.frame.width/2 + self.frame.width*0.1, y: self.frame.height/2)
        self.addChild(visor)
        visor.size = CGSize(width: self.frame.width * 0.7, height: self.frame.height * 0.9)
        visor.zPosition = 3
        
        // adicionando marcadores
        
        let top = SKSpriteNode(imageNamed: "roboReferenceDirection")
        top.colorBlendFactor = 0.7
        top.color = UIColor.redColor()
        top.size = CGSize(width: visor.size.width * 0.9, height: top.size.height)
        top.position = CGPoint(x: visor.position.x, y: visor.position.y + ((visor.size.height/2)*0.975) - top.size.height)
        top.zPosition = 4
        self.addChild(top)
        
        let bot = SKSpriteNode(imageNamed: "roboReferenceDirection")
        bot.colorBlendFactor = 0.7
        bot.color = UIColor.blueColor()
        bot.size = CGSize(width: visor.size.width * 0.9, height: top.size.height)
        bot.position = CGPoint(x: visor.position.x, y: visor.position.y - ((visor.size.height/2)*0.975) + bot.size.height)
        bot.zPosition = 4
        bot.yScale = -1
        self.addChild(bot)
        
        let left = SKSpriteNode(imageNamed: "roboReferenceSides")
        left.colorBlendFactor = 0.7
        left.color = UIColor.brownColor()
        left.size = CGSize(width: left.size.width, height: visor.size.height*0.9)
        left.position = CGPoint(x: visor.position.x - ((visor.size.height/2)*0.99) + left.size.width*0.65, y: visor.position.y)
        left.zPosition = 4
        self.addChild(left)
        
        let right = SKSpriteNode(imageNamed: "roboReferenceSides")
        right.colorBlendFactor = 0.7
        right.color = UIColor.purpleColor()
        right.size = CGSize(width: left.size.width, height: visor.size.height*0.9)
        right.position = CGPoint(x: visor.position.x + ((visor.size.height/2)*0.99) - left.size.width*0.65, y: visor.position.y)
        right.zPosition = 4
        right.xScale = -1
        self.addChild(right)
        
        
    }
    

}
