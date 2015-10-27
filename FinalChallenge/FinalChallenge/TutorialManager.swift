//
//  TutorialManager.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/26/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialManager: NSObject, InformationNodeDelegate {
    
    var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
    
    weak var scene: SKScene!
    var infoBox: InformationBoxNode!
    var infoArrow: InformationArrowNode!
    
    var isIphone = false
    
    var nodeOriginalPosition = CGPointMake(0.0, 0.0)
    
    init(tuples: [(node:SKNode?, text:String?, animation: SKAction?)], scene: SKScene, isIphone: Bool) {
        super.init()
        self.tuples = tuples
        self.scene = scene
        self.isIphone = isIphone
        removeUserInteraction()
    }
    
    func removeUserInteraction() {
        for tuple in tuples {
            if let node = tuple.node {
                node.userInteractionEnabled = false
            }
        }
    }
    
    func showInfo() {
        guard !tuples.isEmpty else {
            return
        }
        
        if let node = tuples.first!.node {
            node.userInteractionEnabled = true
            setupArrow(node)
            if let animation = tuples.first!.animation {
                setupAnimation(node, animation: animation)
            }
            
        }
        
        if let text = tuples.first!.text {
            setupText(text, node: tuples.first!.node)
        }
        
    }
    
    func setupArrow(node:SKNode) {
        if node.position.x > scene.frame.size.width / 2 {
            infoArrow = InformationArrowNode(pointingRight: false, nodeToPoint: node)
        } else {
            infoArrow = InformationArrowNode(pointingRight: true, nodeToPoint: node)
        }
        
        infoArrow.zPosition = 10000
        scene.addChild(infoArrow)
        infoArrow.animate()
    }
    
    func setupAnimation(node:SKNode, animation:SKAction) {
        nodeOriginalPosition = node.position
        node.runAction(animation)
    }
    
    func setupText(text:String, node: SKNode?) {
        infoBox = InformationBoxNode(isIphone: isIphone, text: text)
        infoBox.delegate = self
        
        if node?.position.y > scene.frame.size.height/2 {
            infoBox.position = CGPointMake(scene.frame.size.width/2, infoBox.calculateAccumulatedFrame().height/2)
        } else {
            infoBox.position = CGPointMake(scene.frame.size.width/2, scene.frame.size.height - infoBox.calculateAccumulatedFrame().height/2)
        }
        
        infoBox.position = CGPointMake(scene.frame.size.width/2, infoBox.calculateAccumulatedFrame().height/2)
        infoBox.zPosition = 10000
        
        scene.addChild(infoBox)
    }
    
    func closeInformation() {
        if infoArrow != nil {
            infoArrow.removeFromParent()
        }
        if infoBox != nil {
            infoBox.removeFromParent()
        }
        if tuples.first!.animation != nil {
            tuples.first!.node?.removeAllActions()
            tuples.first!.node?.position = nodeOriginalPosition
        }
        tuples.removeFirst()
        showInfo()
    }
    
    deinit {
        if infoArrow != nil {
            infoArrow.removeFromParent()
        }
        if infoBox != nil {
            infoBox.removeFromParent()
        }
    }
    
    func buttonActivated(node:SKSpriteNode) {
        if let tuple = tuples.first {
            if let node2 = tuple.node {
                if node == node2 {
                    closeInformation()
                }
            }
        }
    }
    
    
}
