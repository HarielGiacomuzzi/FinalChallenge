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
    case DoubleSpeed = "Double Speed"
    case EscapeTraps = "Escape Traps"
    case ExtraDice = "Extra Dice"
    case HalfSpeed = "Half Speed"
    case ChineseVase = "Chinese Vase"
    case FrostMourne = "Frost Mourne"
    case HolyGrail = "Holy Grail"
    case Lamp = "Lamp"
    case Skull = "Skull"
}

class CardManager{
    
    static let ShareInstance = CardManager()
    
    var collectableCount = 0
    var usableCount = 7
    
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
            case "StealGoldCard" : return StealGoldCard()
            case "MoveBackCard" : return MoveBackCard()
            case "LoseCard" : return LoseCard()
            case "Double Speed" : return DoubleSpeed()
            case "Escape Traps": return EscapeTraps()
            case "Extra Dice" : return ExtraDice()
            case "Half Speed" : return HalfSpeed()
            case "Chinese Vase": return self.generateTreasureCard(Cards.ChineseVase)
            case "Frost Mourne" : return self.generateTreasureCard(Cards.FrostMourne)
            case "Holy Grail" : return self.generateTreasureCard(Cards.HolyGrail)
            case "Lamp" : return self.generateTreasureCard(Cards.Lamp)
            case "Skull" : return self.generateTreasureCard(Cards.Skull)
            default :
                return Card()
        }
    }
    //cards = enum
    func getCard(card:Cards) -> Card {
        switch(card){
            //active cards
        case .StealGoldCard: return StealGoldCard()
        case .MoveBackCard : return MoveBackCard()
        case .LoseCard : return LoseCard()
        case .DoubleSpeed : return DoubleSpeed()
        case .EscapeTraps : return EscapeTraps()
        case .ExtraDice : return ExtraDice()
        case .HalfSpeed : return HalfSpeed()
         // not active cards
        case .ChineseVase : return self.generateTreasureCard(Cards.ChineseVase)
        case .FrostMourne : return self.generateTreasureCard(Cards.FrostMourne)
        case .HolyGrail : return self.generateTreasureCard(Cards.HolyGrail)
        case .Lamp : return self.generateTreasureCard(Cards.Lamp)
        case .Skull : return self.generateTreasureCard(Cards.Skull)
        }
    }

    func getRandomCard(isUsable : Bool)-> ActiveCard {
        let rand = Int(arc4random_uniform(UInt32(usableCount-1)))
        var card : Card? = nil
        
        switch(rand){
        case 0 : card = getCard(.LoseCard)
        case 1 : card = getCard(.StealGoldCard)
        case 2 : card = getCard(.MoveBackCard)
        case 3 : card = getCard(.DoubleSpeed)
        case 4 : card = getCard(.EscapeTraps)
        case 5 : card = getCard(.ExtraDice)
        case 6 : card = getCard(.HalfSpeed)
        default : break
        }
        
        return card as! ActiveCard
    }
    
    func sendCard(player:Player, card:Card){
        print(player.items.count)
        guard player.items.count <= 5 else {
            return
        }
        print("continuei")
        player.items.append(card)
        
        let cardData = ["player":player.playerIdentifier, "item": card.cardName]
        let dic = ["addCard":" ", "dataDic" : cardData]
        
        ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
    }
    func generateRandomTreasureCard() -> NotActiveCard{
        let rand = Int(arc4random_uniform(5))
        
        switch(rand){
        case 0 : return self.generateTreasureCard(Cards.ChineseVase)
        case 1 : return self.generateTreasureCard(Cards.FrostMourne)
        case 2 : return self.generateTreasureCard(Cards.HolyGrail)
        case 3 : return self.generateTreasureCard(Cards.Lamp)
        case 4 : return self.generateTreasureCard(Cards.Skull)
        default : break
        }
        return self.generateTreasureCard(Cards.HolyGrail)
    }
    func generateTreasureCard(name:Cards) -> NotActiveCard{
        var card : NotActiveCard? = nil
        
        switch(name){
        case Cards.ChineseVase : card = NotActiveCard(name: "Chinese Vase", value: 10, im: "chinavase")
        case Cards.FrostMourne : card = NotActiveCard(name: "Frost Mourne", value: 50, im: "frostmourne")
        case Cards.HolyGrail :   card = NotActiveCard(name: "Holy Grail", value: 100, im: "holygrail")
        case Cards.Lamp : card = NotActiveCard(name: "Lamp", value: 200, im: "lamp")
        case Cards.Skull: card = NotActiveCard(name: "Skull", value: 500, im: "skull")
        default : card = NotActiveCard(name: "Holy Grail", value: 100, im: "holygrail")
        }
        return card!
    }
}