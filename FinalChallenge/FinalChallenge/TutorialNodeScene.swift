//
//  TutorialNodeScene.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 10/16/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import SpriteKit

class TutorialNodeScene : SKSpriteNode {
    var pageNumber = 0
    var t = [SKTexture()]
    var nextButton : SKSpriteNode?
    var backButton : SKSpriteNode?
    var closeButton : SKSpriteNode?
    
    var tutorialNodeSize : CGSize?
    
    init(texture:SKTexture,size:CGSize){
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.pageNumber = 0
        
        self.userInteractionEnabled = true
        
        self.texture = texture
        self.name = "Tutorial Scene"
        nextButton = SKSpriteNode(texture: SKTexture(imageNamed: "tutorialnextbutton"), size: CGSize(width: 40.0, height: 40.0))
        nextButton?.name = "next button"
        nextButton?.color = UIColor.redColor()
        nextButton?.colorBlendFactor = 0.5
        nextButton?.position.x = self.frame.width/2.5
        nextButton?.position.y = -self.frame.height/2.5
        nextButton?.zPosition = 500
        
        if t.count >= 1{
            self.addChild(nextButton!)
        }
        
        backButton = SKSpriteNode(texture: SKTexture(imageNamed: "tutorialbackbutton"), size: CGSize(width: 40.0, height: 40.0))
        backButton?.name = "back button"
        backButton?.color = UIColor.redColor()
        backButton?.colorBlendFactor = 0.5
        backButton?.position.x = -self.frame.width/2.5
        backButton?.position.y = -self.frame.height/2.5
        backButton?.zPosition = 500
        
        closeButton = SKSpriteNode(texture: SKTexture(imageNamed: "x"), size: CGSize(width: 20.0, height: 20.0))
        closeButton?.name = "close button"
        closeButton?.position.x = -self.frame.width/2.5
        closeButton?.position.y = self.frame.height/2.5
        closeButton?.zPosition = 500
        self.addChild(closeButton!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
        if(nextButton!.containsPoint(location)) && self.pageNumber < t.count - 1{
            self.pageNumber++
            self.texture = t[self.pageNumber]
            if self.pageNumber == 1{
                self.addChild(backButton!)
            }
            if t.count - 1 == pageNumber{
                nextButton?.removeFromParent()
            }
        }

        if(backButton!.containsPoint(location)) && self.pageNumber > 0{
            self.pageNumber--
            self.texture = t[self.pageNumber]
            if pageNumber == 0 {
                backButton?.removeFromParent()
            }
            if pageNumber == t.count - 2{
                self.addChild(nextButton!)
            }
        }
        if(closeButton!.containsPoint(location)){
            self.removeFromParent()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("Deu deinit")
    }
}
