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
    
    var cards : [SKNode]?
    weak var delegate : CardShowDelegate?
    var cardFrame = CGRectMake(0, 0, 0, 0)
    
    //requires cardsArray.count == 5
    init(cardsArray:[SKNode]) {
        super.init()
        cardFrame = (cardsArray.first?.calculateAccumulatedFrame())!

        cardsArray[1].position = CGPointMake(-cardFrame.width/2, 0.0)
        cardsArray[3].position = CGPointMake(cardFrame.width/2, 0.0)
        cardsArray[0].position = CGPointMake(cardsArray[1].position.x - cardFrame.width/2, 0.0)
        cardsArray[4].position = CGPointMake(cardsArray[3].position.x + cardFrame.width/2, 0.0)
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

                if cards![i] == touchedNode.parent {
                    let testCard = cards![i] as! CardSprite
                    print(testCard.card)
                    fixCardsZPosition(i)
                    delegate?.cardChosen(cards![i])
                }
            }
            
        }

    }
    
    func removeCard(card:SKNode) {
        card.removeFromParent()
    }
    
    func fixCardsZPosition(centerIndex:Int) {
        var counter : CGFloat = 50
        for i in 0..<centerIndex {
            cards![i].zPosition = counter
            counter+=10
            cards![i].setScale(1.0)
        }
        cards![centerIndex].zPosition = 100
        cards![centerIndex].setScale(1.1)
        for i in centerIndex+1..<cards!.count {
            cards![i].zPosition = counter
            counter-=10
            cards![i].setScale(1.0)
        }
        
    }
}

protocol CardShowDelegate : class {
    func cardChosen(sender:SKNode)
}
