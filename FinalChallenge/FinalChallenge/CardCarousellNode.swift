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
    var leftPoint = CGPointMake(0.0, 0.0)
    var rightPoint = CGPointMake(0.0, 0.0)
    var centerIndex:Int = 0
    var canRemoveWithSwipeUp = true
    var firstTouch = false
    var movingUp = false
    var delegate:CardCarousellDelegate?
    
    // MARK: - Initialization
    
    //startIndex must be inside array...
    init(cardsArray:[SKSpriteNode], startIndex:Int) {
        super.init()
        cards = cardsArray
        centerIndex = startIndex
        userInteractionEnabled = true
        centerPoint = CGPointMake(0, 0)
        
        leftPoint = CGPointMake(centerPoint.x - cards[0].size.width * 0.75, centerPoint.y)
        rightPoint = CGPointMake(centerPoint.x + cards[0].size.width * 0.75, centerPoint.y)
        
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
            firstTouch = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let centerCard = cards[centerIndex]
        if centerCard.position.y > centerPoint.y {
            removeCard()
        } else {
            fixCardsZPosition()
            fixCardsXPosition()
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
            if centerCard.position.x > centerPoint.x {
                if centerIndex > 0 {
                    let leftCard = cards[centerIndex - 1]
                    let newLeftPos = changeInX + leftCard.position.x
                    if newLeftPos > rightPoint.x {
                        leftCard.position = rightPoint
                        leftCard.setScale(0.75)
                    } else if newLeftPos < leftPoint.x {
                        leftCard.position = leftPoint
                        leftCard.setScale(0.75)
                    } else {
                        leftCard.position.x = newLeftPos
                        fixScale(leftCard)
                    }
                }
            } else {
                if centerIndex < cards.count - 1 {
                    let rightCard = cards[centerIndex + 1]
                    let newRightPos = changeInX + rightCard.position.x
                    if newRightPos > rightPoint.x {
                        rightCard.position = rightPoint
                        rightCard.setScale(0.75)
                    } else if newRightPos < leftPoint.x {
                        rightCard.position = leftPoint
                        rightCard.setScale(0.75)
                    } else {
                        rightCard.position.x = newRightPos
                        fixScale(rightCard)
                    }
                }
            }
            centerCard.position.x = newCenterPos
        }
        fixScale(centerCard)
    }
    
    
    // MARK: - Add/Remove Cards
    
    func insertCard(card:SKSpriteNode) {
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
            card.zPosition = card.size.height * 0.01
        }
        
        cards[centerIndex].zPosition += 0.5
        if centerIndex > 0 {
            cards[centerIndex - 1].zPosition += 0.1
        }
        if centerIndex < cards.count - 1 {
            cards[centerIndex + 1].zPosition += 0.1
        }
        
    }
    
    func fixScale(card:SKSpriteNode) {
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