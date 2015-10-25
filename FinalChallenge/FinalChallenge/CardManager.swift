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
    case BronzeCard = "Bronze Card"
    case SilverCard = "Silver Card"
    case GoldCard = "Gold Card"
    case PlatinumCard = "Platinum Card"
    case DiamondCard = "Diamond Card"
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
                return Card()
        }
    }
    //cards = enum
    func getCard(card:Cards) -> Card {
        switch(card){
        case .StealGoldCard: return StealGoldCard()
        case .MoveBackCard : return MoveBackCard()
        case .LoseCard : return LoseCard()
        case .BronzeCard : return self.generateTreasureCard(Cards.BronzeCard)
        case .SilverCard : return self.generateTreasureCard(Cards.SilverCard)
        case .GoldCard : return self.generateTreasureCard(Cards.GoldCard)
        case .PlatinumCard : return self.generateTreasureCard(Cards.PlatinumCard)
        case .DiamondCard : return self.generateTreasureCard(Cards.DiamondCard)
        }
    }

    func getRandomCard(isUsable : Bool)-> ActiveCard {
        let rand = Int(arc4random_uniform(UInt32(usableCount-1)))
        var card : Card? = nil
        if rand == 1{
            card = getCard(.StealGoldCard)
        }
        if rand == 2{
            card = getCard(.MoveBackCard)
        }
        if rand == 0{
            card = getCard(.LoseCard)
        }
        return card as! ActiveCard
    }
    
    func sendCard(player:Player, card:Card){
        player.items.append(card)
        
        let cardData = ["player":player.playerIdentifier, "item": card.cardName]
        let dic = ["addCard":" ", "dataDic" : cardData]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    func generateRandomTreasureCard() -> NotActiveCard{
        let rand = Int(arc4random_uniform(5))
        
        switch(rand){
        case 0 : return self.generateTreasureCard(Cards.BronzeCard)
        case 1 : return self.generateTreasureCard(Cards.SilverCard)
        case 2 : return self.generateTreasureCard(Cards.GoldCard)
        case 3 : return self.generateTreasureCard(Cards.PlatinumCard)
        case 4 : return self.generateTreasureCard(Cards.DiamondCard)
        default : break
        }
        return self.generateTreasureCard(Cards.GoldCard)
    }
    func generateTreasureCard(name:Cards) -> NotActiveCard{
        var card : NotActiveCard? = nil
        
        switch(name){
        case Cards.BronzeCard : card = NotActiveCard(name: "Bronze Card", value: 10)
                             card?.imageName = "bronzecard"
        case Cards.SilverCard : card = NotActiveCard(name: "Silver Card", value: 50)
                             card?.imageName = "silvercard"
        case Cards.GoldCard :  card = NotActiveCard(name: "Gold Card", value: 100)
                            card?.imageName = "goldcard"
        case Cards.PlatinumCard : card = NotActiveCard(name: "Platinum Card", value: 200)
                               card?.imageName = "platinumcard"
        case Cards.DiamondCard: card = NotActiveCard(name: "Diamond Card", value: 500)
                               card?.imageName = "diamondcard"
        default : card = NotActiveCard(name: "Gold Card", value: 100)
                    card?.imageName = "goldcard"
        }
        return card!
    }
}