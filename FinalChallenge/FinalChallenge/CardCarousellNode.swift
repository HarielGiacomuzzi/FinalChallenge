//
//  CardCarouselNode.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/16/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class CardCarouselNode: SKNode {
    
    var touchedPoint:CGPoint = CGPointMake(0.0, 0.0)
    var cards:[SKSpriteNode] = []
    var centerPoint = CGPointMake(0.0, 0.0)
    var leftCardPoint = CGPointMake(0.0, 0.0)
    var rightCardPoint = CGPointMake(0.0, 0.0)
    var centerIndex:Int = 0
    
    init(cardsArray:[SKSpriteNode]) {
        super.init()
        cards = cardsArray
        userInteractionEnabled = true
        centerPoint = CGPointMake(0, 0)
        
        //change left and right points to change distance between cards
        leftCardPoint = CGPointMake(centerPoint.x - cards[0].size.width * 0.75, centerPoint.y)
        rightCardPoint = CGPointMake(centerPoint.x + cards[0].size.width * 0.75, centerPoint.y)
        
        for card in cards {
            card.position = leftCardPoint
            card.setScale(0.75)
            addChild(card)
        }
        cards[centerIndex].zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            touchedPoint = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let centerCard = cards[centerIndex]
            centerCard.position = centerPoint
            centerCard.setScale(1.0)
            fixCardsZPosition()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let changeInX = location.x - touchedPoint.x
            let centerCard = cards[centerIndex]
            
            fixCardsZPosition()
            fixScale(centerCard)
            
            let newPos = centerCard.position.x + changeInX
            
            if newPos > rightCardPoint.x {
                centerCard.position = rightCardPoint
                centerCard.setScale(0.75)
                if centerCard != cards.last {
                    centerIndex++
                }
            } else if newPos < leftCardPoint.x {
                centerCard.position = leftCardPoint
                centerCard.setScale(0.75)
                if centerCard != cards.first {
                    centerIndex--
                }
            } else {
                centerCard.position.x = newPos
            }
            
            touchedPoint = location
        }
    }
    
    func fixCardsZPosition() {
        for card in cards {
            card.zPosition = 1
        }
        cards[centerIndex].zPosition = 3
        if centerIndex - 1 >= 0 {
            cards[centerIndex - 1].zPosition = 2
        }
        if centerIndex + 1 < cards.count {
            cards[centerIndex + 1].zPosition = 2
        }
        
    }
    
    func fixScale(card:SKSpriteNode) {
        if card.position.x > leftCardPoint.x && card.position.x <= centerPoint.x {
            let fullSize = centerPoint.x - leftCardPoint.x
            let currentSize = card.position.x - leftCardPoint.x
            
            var aux = currentSize / fullSize
            aux = aux * 0.25 + 0.75
            card.setScale(aux)
            
        }
        
        if card.position.x < rightCardPoint.x && card.position.x >= centerPoint.x {
            let fullSize = rightCardPoint.x - centerPoint.x
            let currentSize = rightCardPoint.x - card.position.x
            var aux = currentSize / fullSize
            aux = aux * 0.25 + 0.75
            card.setScale(aux)
            
        }
    }
}