//
//  PartyModeScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 9/1/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

private let movableAvatarNodeName = "movable"

class PartyModeScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "board_beta")
    var selectedNode = SKSpriteNode()
    var playerSpriteNodeArray = [SKSpriteNode()]
    var beginPosition = CGPoint()
    let imageNames = ["Red", "White", "Blue", "Black"]

    
    override init(size: CGSize) {
        super.init(size: size)

        self.background.name = "background"
        self.background.anchorPoint = CGPointZero
        self.addChild(background)
    
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let sprite = SKSpriteNode(imageNamed: imageName)
            
            sprite.name = imageName

            sprite.size = CGSize(width: 50, height: 50)
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            sprite.position = CGPoint(x: size.width * offsetFraction, y: size.height/2)
            
            self.addChild(sprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        self.view!.addGestureRecognizer(gestureRecognizer)
    }
    
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            var touchLocation = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            self.selectNodeForTouch(touchLocation)
            
        } else if recognizer.state == .Changed {
            var translation = recognizer.translationInView(recognizer.view!)
            translation = CGPoint(x: translation.x, y: -translation.y)
            
            self.panForTranslation(translation)
            
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        } else if recognizer.state == .Ended {
            for sp in imageNames{
                if selectedNode.name != sp {
                    let scrollDuration = 0.2
                    let velocity = recognizer.velocityInView(recognizer.view)
                    let pos = selectedNode.position
                
                    // This just multiplies your velocity with the scroll duration.
                    let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                    selectedNode.removeAllActions()
                }else{
                    if selectedNode.position.y > self.frame.height/1.2{
                        self.sendDataToIpad()
                    } else {
                        self.selectedNode.position = self.beginPosition
                    }
                }
            }
            
        }
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * M_PI)
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        // 1
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode.removeAllActions()
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                
        
                for sp in imageNames{
                    if touchedNode.name! == sp {
                        let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                            SKAction.rotateByAngle(0.0, duration: 0.1),
                            SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                        self.beginPosition = self.selectedNode.position
                        selectedNode.runAction(SKAction.repeatActionForever(sequence))
                    }
                }
            }
        }
    }
    
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        for sp in imageNames{
            if selectedNode.name! == sp {
                selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            }
        }
    }
    
    
    func sendDataToIpad(){
        println(self.selectedNode.name)
        if let avatarName : String = self.selectedNode.name{
            self.selectedNode.removeFromParent()
            var avatar = ["avatar":avatarName]
            var dic = ["GameSetup":"", "avatar":avatar]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        }
    }
    
}

