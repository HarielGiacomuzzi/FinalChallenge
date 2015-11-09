//
//  TutorialManager.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/26/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialManager: NSObject, InformationNodeDelegate, ArrowDelegate {
    
    var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = [] {
        didSet {
            print("didSetTuples: \(tuples)")
            removeUserInteraction()
        }
    }
    
    weak var scene: SKScene!
    var infoBox: InformationBoxNode!
    var infoArrow: InformationArrowNode!
    
    var isActive = false
    
    var boxScale: CGFloat = 1.0
    
    var isIphone = false
    
    var nodeOriginalPosition = CGPointMake(0.0, 0.0)
    
    init(tuples: [(node:SKNode?, text:String?, animation: SKAction?)], scene: SKScene, isIphone: Bool, boxScale: CGFloat) {
        super.init()
        self.tuples = tuples
        self.scene = scene
        self.isIphone = isIphone
        self.boxScale = boxScale
        removeUserInteraction()
    }
    
    func removeUserInteraction() {
        guard tuples.count > 1 else {
            return
        }
        for i in 1..<tuples.count {
            if let node = tuples[i].node {
                node.userInteractionEnabled = false
            }
        }
    }
    
    func showInfo() {
        guard !tuples.isEmpty else {
            isActive = false
            return
        }
        isActive = true
        
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
            infoArrow = InformationArrowNode(pointingRight: true, nodeToPoint: node)
        } else {
            infoArrow = InformationArrowNode(pointingRight: false, nodeToPoint: node)
        }
        infoArrow.setScale(boxScale)
        infoArrow.positionArrow()
        infoArrow.zPosition = 10000
        scene.addChild(infoArrow)
        infoArrow.delegate = self
        infoArrow.animate()
    }
    
    func setupAnimation(node:SKNode, animation:SKAction) {
        nodeOriginalPosition = node.position
        node.runAction(animation)
    }
    
    func setupText(text:String, node: SKNode?) {
        infoBox = InformationBoxNode(isIphone: isIphone, text: text)
        infoBox.delegate = self
        
        infoBox.setScale(boxScale)
        
        infoBox.position = CGPointMake(scene.frame.size.width/2, infoBox.calculateAccumulatedFrame().height/2)
        if let n = node {
            if n.position.y < infoBox.position.y + infoBox.calculateAccumulatedFrame().height/2 {
                infoBox.position = CGPointMake(scene.frame.size.width/2, scene.frame.size.height - infoBox.calculateAccumulatedFrame().height/2)
            }
        }
        
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
        if tuples.first?.animation != nil {
            tuples.first!.node?.removeAllActions()
            tuples.first!.node?.position = nodeOriginalPosition
        }
        if !tuples.isEmpty {
            tuples.removeFirst()
        }
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
    
    func buttonActivated(node:SKNode) {
        if let tuple = tuples.first {
            if let node2 = tuple.node {
                if node == node2 {
                    closeInformation()
                }
            }
        }
    }
    
    func arrowTouched() {
        closeInformation()
    }
    
    static func loadStringsPlist(name:String) -> [String] {
        let path = NSBundle.mainBundle().pathForResource("TutorialTexts", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict![name] as! [String]
    }
    
    
}
