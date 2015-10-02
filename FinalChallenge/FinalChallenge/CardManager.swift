//
//  CardManager.swift
//  FinalChallenge
//
//  Created by Cristiane on 02/10/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

enum Cards : String {
    case StealGoldCard = "StealGoldCard"
    case MoveBackCard = "MoveBackCard"
    case LoseCard = "LoseCard"
}

class CardManager{
    
    static let ShareInstance = CardManager()
    
    var collectableCount = 0
    var usableCount = 3
    
    

    // this function takes a card from a player
    func loseCard(player:Player){
    let value = player.items.count
    let indexCard : Int = (random() % value)
    player.items.removeAtIndex(indexCard)

    let removedCard = player.items[indexCard]
    let cardData = ["player":player.playerIdentifier, "item": removedCard]
    let dic = ["removeCard":" ", "dataDic" : cardData]

    ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }

    // given a card name this function returns you the corresponding card
    func getCard(name:String) -> Card {
    switch(name){
    case "StealGoldCard" :
        return StealGoldCard()
    case "MoveBackCard" :
        return MoveBackCard()
    case "LoseCard" :
        return LoseCard()
    default :
        print("entrei no default deu ruim gente")
        return Card()

    }
}
    //cards = enum
    func getCard(card:Cards) -> Card {
        switch(card){
        case .StealGoldCard:
            return StealGoldCard()
        case .MoveBackCard :
            return MoveBackCard()
        case .LoseCard :
            return LoseCard()
        default :
            print("entrei no default deu ruim gente")
            return Card()
            
        }
    }

    func getRandomCard(isUsable : Bool)-> ActiveCard {
        let rand = Int(arc4random_uniform(UInt32(usableCount-1)))
        var card : Card? = nil
        if rand == 1{
        card = getCard(.StealGoldCard)
        }
        if rand == 2{
        card == getCard(.MoveBackCard)
        }
        if rand == 0{
        card == getCard(.LoseCard)
        }
        return card as! ActiveCard
    }
    
}