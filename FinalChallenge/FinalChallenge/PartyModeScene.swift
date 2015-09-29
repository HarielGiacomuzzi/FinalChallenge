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
    
    weak var viewController : iPhonePlayerViewController?
    let background = SKSpriteNode(imageNamed: "board_beta")
    var selectedNode = SKSpriteNode()
    var playerSpriteNodeArray = [SKSpriteNode()]
    var beginPosition = CGPoint()
    let imageNames = ["red", "white", "blue", "black"]
    var takenAvatar = [String()]
    var takenFlag = Bool()
    var arrayAvatarSprite = [SKSpriteNode()]
    
    override init(size: CGSize) {
        super.init(size: size)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_IphoneGameSetup", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeView:", name: "ConnectionManager_IphoneChangeView", object: nil);
        
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
            
            sprite.zPosition = 100
            
            arrayAvatarSprite.append(sprite)
            
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
                    _ = selectedNode.position
                
                    // This just multiplies your velocity with the scroll duration.
                    _ = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                    selectedNode.removeAllActions()
                }else{
                    if selectedNode.position.y > self.frame.height/1.2{
                        for ta in takenAvatar{
                            if ta != sp{
                                takenFlag = false
                            } else {
                                takenFlag = true
                                break
                            }
                        }
                        if takenFlag == false{
                            self.sendDataToIpad()
                        } else {
                            self.selectedNode.position = self.beginPosition
                        }
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
        print(self.selectedNode.name)
        if let avatarName : String = self.selectedNode.name{
            let avatar = ["avatar":avatarName]
            let dic = ["GameSetup":" ", "avatar":avatar]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
        }
        self.selectedNode.position = self.beginPosition
    }
    
    func messageReceived(data : NSNotification){
        _ = data.userInfo!["peerID"] as! String
        let dictionary = data.userInfo!["arrayPlayers"] as! NSDictionary
        let message = dictionary["arrayPlayers"] as! [String]
        self.takenAvatar = message
        print(self.takenAvatar)
        
        // muda formato das imagens identificando se foi pego ou nao
        for sprite in arrayAvatarSprite{
            for taken in takenAvatar{
                if sprite.name == taken{
                    sprite.size = CGSize(width: 25, height: 25)
                    break
                } else {
                    sprite.size = CGSize(width: 50, height: 50)
                }
            }
        }
        
    }
    
    func changeView(data : NSNotification){
        let dictionary = data.userInfo!["change"] as! NSDictionary
        let message = dictionary["change"] as! String
        
        if message == "change" {
            //change view
            viewController?.loadPlayerView()
        }
        
    }
    
}


