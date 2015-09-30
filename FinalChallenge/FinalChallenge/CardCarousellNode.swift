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
    
    var cardFrame = CGRectMake(0, 0, 0, 0)
    var touchedPoint:CGPoint = CGPointMake(0.0, 0.0)
    var cards:[SKNode] = []
    var centerPoint = CGPointMake(0.0, 0.0)
    var leftPoint = CGPointMake(0.0, 0.0)
    var rightPoint = CGPointMake(0.0, 0.0)
    var centerIndex:Int = 0
    var canRemoveWithSwipeUp = true
    var firstTouch = false
    var movingUp = false
    var checkTouch:CGPoint = CGPointMake(0.0, 0.0)
    weak var delegate:CardCarousellDelegate?
    
    // MARK: - Initialization
    
    //startIndex must be inside array...
    init(cardsArray:[SKNode], startIndex:Int) {
        super.init()
        cards = cardsArray
        centerIndex = startIndex
        userInteractionEnabled = true
        centerPoint = CGPointMake(0, 0)
        cardFrame = cards[0].calculateAccumulatedFrame()

        leftPoint = CGPointMake(centerPoint.x - cardFrame.width * 0.75, centerPoint.y)
        rightPoint = CGPointMake(centerPoint.x + cardFrame.width * 0.75, centerPoint.y)

        fixCardsXPosition()
        fixCardsZPosition()
        
        for card in cards {
            addChild(card)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            touchedPoint = location
            checkTouch = location
            firstTouch = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if location == checkTouch {
                let touchedNode = nodeAtPoint(location)
                
                if centerIndex > 0 {
                    if touchedNode.parent == cards[centerIndex-1] {
                        centerIndex--
                        fixCardsXPosition()
                    }
                }
                
                if centerIndex < cards.count - 1 {
                    if touchedNode.parent == cards[centerIndex+1] {
                        centerIndex++
                        fixCardsXPosition()
                        
                    }
                }
            }
        }
        
        let centerCard = cards[centerIndex]
        if centerCard.position.y > centerPoint.y {
            removeCard()
        } else {
            fixCardsZPosition()
            centerCard.position = centerPoint
            centerCard.setScale(1.0)
        }

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let changeInX = location.x - touchedPoint.x
            let changeInY = location.y - touchedPoint.y
            let centerCard = cards[centerIndex]
            
            fixCardsZPosition()

            if firstTouch {
                if fabs(changeInX) > changeInY {
                    movingUp = false
                } else {
                    movingUp = true
                }
            }
            
            if movingUp && canRemoveWithSwipeUp {
                moveUp(centerCard.position.y + changeInY)
            } else {
                moveSideways(changeInX)
            }

            firstTouch = false
            touchedPoint = location
        }
    }
    
    // MARK: - Card Movement
    
    func moveUp(newPos:CGFloat) {
        let centerCard = cards[centerIndex]
        if newPos > centerPoint.y {
            centerCard.position.y = newPos
        } else {
            centerCard.position = centerPoint
        }
    }

    
    func moveSideways(changeInX:CGFloat) {
        let centerCard = cards[centerIndex]
        let newCenterPos = centerCard.position.x + changeInX
        
        if newCenterPos > rightPoint.x {
            centerCard.position = rightPoint
            centerCard.setScale(0.75)
            if centerIndex > 0 {
                centerIndex--
            }
        } else if newCenterPos < leftPoint.x {
            centerCard.position = leftPoint
            centerCard.setScale(0.75)
            if centerIndex < cards.count - 1 {
                centerIndex++
            }
        } else {
            centerCard.position.x = newCenterPos
        }
        fixScale(centerCard)
    }
    
    
    // MARK: - Add/Remove Cards
    
    func insertCard(card:SKNode) {
        cards.append(card)
        if cards.count == 1 {
            card.position = centerPoint
            card.setScale(1.0)
        } else {
            card.position = leftPoint
            card.setScale(0.75)
        }
        addChild(card)
        fixCardsZPosition()
    }
    
    func removeCard() {
        removeCard(centerIndex)
    }
    
    func removeCard(index:Int) {
        if !cards.isEmpty {
            delegate?.sendCard(cards[index])
            cards[index].removeFromParent()
            cards.removeAtIndex(index)
            
            if !cards.isEmpty {
                if centerIndex >= cards.count {
                    centerIndex = cards.count - 1
                }
                let centerCard = cards[centerIndex]
                centerCard.position = centerPoint
                centerCard.setScale(1.0)
                fixCardsZPosition()
            }
        }
    }
    
    
    // MARK: - Auxiliar Functions
    
    func fixCardsZPosition() {
        for card in cards {
            card.zPosition = 1
        }
        
        cards[centerIndex].zPosition = 30
        if centerIndex > 0 {
            cards[centerIndex - 1].zPosition = 20
        }
        if centerIndex < cards.count - 1 {
            cards[centerIndex + 1].zPosition  = 20
        }
        
    }
    
    func fixScale(card:SKNode) {
        if card.position.x > leftPoint.x && card.position.x <= centerPoint.x {
            let fullSize = centerPoint.x - leftPoint.x
            let currentSize = card.position.x - leftPoint.x
            
            var aux = currentSize / fullSize
            aux = aux * 0.25 + 0.75
            card.setScale(aux)
            
        }
        
        if card.position.x < rightPoint.x && card.position.x >= centerPoint.x {
            let fullSize = rightPoint.x - centerPoint.x
            let currentSize = rightPoint.x - card.position.x
            var aux = currentSize / fullSize
            aux = aux * 0.25 + 0.75
            card.setScale(aux)
            
        }
    }
    
    func fixCardsXPosition() {
        for i in 0..<cards.count {
            if i < centerIndex {
                cards[i].position = leftPoint
                cards[i].setScale(0.75)
            }
            if i == centerIndex {
                cards[i].position = centerPoint
                cards[i].setScale(1.0)
            }
            if i > centerIndex {
                cards[i].position = rightPoint
                cards[i].setScale(0.75)
            }
        }
    }
    
    
}

protocol CardCarousellDelegate : class {
    func sendCard(card:SKNode)
}