//
//  CardShowNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/28/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class CardShowNode: SKNode {
    
    var cards : [SKSpriteNode]?
    weak var delegate : CardShowDelegate?
    
    //requires cardsArray.count == 5
    init(cardsArray:[SKSpriteNode]) {
        super.init()
        
        cardsArray[1].position = CGPointMake(-cardsArray[1].size.width/2, 0.0)
        cardsArray[3].position = CGPointMake(cardsArray[3].size.width/2, 0.0)
        cardsArray[0].position = CGPointMake(cardsArray[1].position.x - cardsArray[0].size.width/2, 0.0)
        cardsArray[4].position = CGPointMake(cardsArray[3].position.x + cardsArray[4].size.width/2, 0.0)
        cards = cardsArray
        
        for card in cards! {
            addChild(card)
        }
        fixCardsZPosition(2)
        userInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            for i in 0..<cards!.count {
                if cards![i] == touchedNode {
                    fixCardsZPosition(i)
                    delegate?.cardChosen(cards![i])
                }
            }
            
        }

    }
    
    func removeCard(card:SKSpriteNode) {
        card.removeFromParent()
    }
    
    func fixCardsZPosition(centerIndex:Int) {
        var counter : CGFloat = 5
        for i in 0..<centerIndex {
            cards![i].zPosition = counter
            counter++
            cards![i].setScale(1.0)
        }
        cards![centerIndex].zPosition = 15
        cards![centerIndex].setScale(1.1)
        for i in centerIndex+1..<cards!.count {
            cards![i].zPosition = counter
            counter--
            cards![i].setScale(1.0)
        }
        
    }
}

protocol CardShowDelegate : class {
    func cardChosen(sender:SKSpriteNode)
}
