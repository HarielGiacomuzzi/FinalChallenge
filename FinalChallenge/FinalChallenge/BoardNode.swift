//
//  BoardNode.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 10/8/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

class BoardNode : NSObject{
    var nextMoves : [BoardNode] = [];
    var posX = 0.0;
    var posY = 0.0;
    var item : Card? {
        didSet {
            if item != nil {
                if item!.usable {
                    let usableItem = item as! ActiveCard
                    if usableItem.used {
                        NSNotificationCenter.defaultCenter().postNotificationName("BoardNode_TrapAdded", object: self)
                    }
                }
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("BoardNode_TrapRemoved", object: self)
            }
        }
    }
    var isSpecialNode = false;
    var coins : Int?
    var nextNames : [String] = [];
    var currentPlayers : [Player] = [];
    var father : BoardNode?
    
    override init() {
        super.init();
    }
    
    func hasNext(node : BoardNode) -> Bool{
        for x in nextMoves{
            if x == node{
                return true;
            }
        }
        return false;
    }
    
    func removePlayer(player : Player?){
        currentPlayers.removeObject(player!);
    }
    
    func activateNode(nodeName : String, player : Player){
        if !self.isSpecialNode{
            return
        }
        switch nodeName{
        case "House":
            var lootValue = 0
            for item in player.items{
                if !item.usable{
                    player.itemsInHouse.append(item);
                    player.items.removeObject(item);
                    if let special = item as? NotActiveCard {
                        lootValue += special.endGameValue
                    }
                    GameManager.sharedInstance.removeCard(player, item: item)
                }

            }
            player.lootPoints += lootValue
            GameManager.sharedInstance.updatePlayerLoot(player, value: lootValue)
            break
            
        case "Store":
            var cards: [Card] = []
            for _ in 0...2 {
                cards.append(CardManager.ShareInstance.getRandomCard(true))
            }
            for _ in 0...1 {
                cards.append(CardManager.ShareInstance.getRandomCard(false))
            }
            var cardsString: [String] = []
            for card in cards {
                cardsString.append(card.cardName)
            }
            let dataDic = ["cards":cardsString,"player":player.playerIdentifier]
            let dic = ["openStore":" ", "dataDic":dataDic]
            ConnectionManager.sharedInstance.sendDictionaryToPeer(dic, reliable: true)
            GameManager.sharedInstance.isOnStore = true;
            
            break
            
            //o dafault é ser um baú
        default:
            if arc4random_uniform(UInt32(1)) >= 1{
                CardManager.ShareInstance.loseCard(player);
            }else{
                //deve estar funcionando :P, cair no bau e rezar xD
                let card = CardManager.ShareInstance.generateRandomTreasureCard()
                CardManager.ShareInstance.sendCard(player, card: card)
            }
            break
        }
        return
    }
    
    func insertPLayer(player : Player?){
        currentPlayers.append(player!);
    }
    
    func hasPlayer(player : NSObject) -> Bool{
        for aux in currentPlayers{
            if aux.isEqual(player){
                return true;
            }
        }
        return false;
    }
    
    // defines if the node will carry an item or not
    func setupItems(){
        let willHaveItem : Int = (random() % 2)
        
        switch(willHaveItem){
        case 0: //print("Adding card")
            self.addItem()
        case 1: //print("No card Added")
            self.item = nil
        default: break
        }
    }
    
    // defines witch item the node will carry
    func addItem(){
        let willBeUsable : Int = (random() % 2)
        
        switch(willBeUsable){
        case 0:
                let witchOneWillBe : Int = (random() % 3) // this number may vary
                switch(witchOneWillBe){
                case 0: let it = StealGoldCard()
                        it.used = false
                        self.item = it
                        print("Card StealGoldCard added")
                case 1: let it = MoveBackCard()
                        it.used = false
                        self.item = it
                        print("Card MoveBackCard added")
                case 2: let it = LoseCard()
                        it.used = false
                        self.item = it
                        print("Card LoseCard added")
                default: break
                }
            
        case 1:
                let it = CardManager.ShareInstance.generateRandomTreasureCard() //we may need to pass a value
                self.item = it
            
        default: break
        }
    }
    
    init(posX : Double, posY : Double, father : BoardNode?) {
        super.init();
        self.father = father;
        self.posX = posX;
        self.posY = posY;
        
        //add only treasurecards in all houses
//        let it = CardManager.ShareInstance.generateRandomTreasureCard() //we may need to pass a value
//        self.item = it
        
        //add only stealgoldcard in all houses
        let it = MoveBackCard()
        it.used = true
        self.item = it
        
        // add ramdonly the itens
        //self.setupItems()
    }
}
