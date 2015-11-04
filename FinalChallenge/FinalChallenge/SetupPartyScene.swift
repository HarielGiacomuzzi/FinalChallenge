//
//  SetupPartyScene.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 08/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

class SetupPartyScene: SKScene, SKPhysicsContactDelegate, SetupPartyButtonDelegate {
    
    
    weak var viewController : PartyModeViewControllerIPAD!
    
    var tutorialManager: TutorialManager!
    
    // set buttons and nodes
    var banner : SKSpriteNode?
    var turns : SetupPartyButton?
    var connect : SetupPartyButton?
    var go : SetupPartyButton?
    var backButton : SetupPartyButton?
    var numberOfTurns : SKLabelNode?
    var connectLabel : SKLabelNode?
    var back : SKLabelNode?
    let fontSize : CGFloat = 20.0
    var info : SKSpriteNode?
    var titleLabel : SKLabelNode?
    
    // characters nodes
    let char1 : SKSpriteNode = SKSpriteNode(imageNamed: "knight")
    let char2 : SKSpriteNode = SKSpriteNode(imageNamed: "ranger")
    let char3 : SKSpriteNode = SKSpriteNode(imageNamed: "thief")
    let char4 : SKSpriteNode = SKSpriteNode(imageNamed: "wizard")
    var charScale:CGFloat = 0.60
    
    var charInitialPosition : CGFloat?

    // set textures
    let yellowButton : SKTexture = SKTexture(imageNamed: "yellowButton")
    let yellowButtonOff : SKTexture = SKTexture(imageNamed: "yellowButtonOff")
    let redBanner : SKTexture = SKTexture(imageNamed: "redTitle")
    let greenButton : SKTexture = SKTexture(imageNamed: "greenButtonOn")
    let greenButtonOff : SKTexture = SKTexture(imageNamed: "greenButtonOff")
    let yellowTurnsOn : SKTexture = SKTexture(imageNamed: "turnsOn")
    let yellowTurnsOff : SKTexture = SKTexture(imageNamed: "turnsOff")

    let arrowOn : SKTexture = SKTexture(imageNamed: "arrowButtonOn")
    let arrowOff : SKTexture = SKTexture(imageNamed: "arrowButtonOff")
    
    var popupAtlas:SKTextureAtlas!
    
    // colisions
    let boundaryCategoryMask: UInt32 =  0x1 << 1
    let fallingCategoryMask: UInt32 =  0x1 << 2
    
    //flags
    var canGo = false

    var turnCounter = 5
    
    override func update(currentTime: NSTimeInterval) {
        for i in 0..<GameManager.sharedInstance.players.count{
            //print("Entrou na mudanca")
            for j in i+1..<GameManager.sharedInstance.players.count{
                if (GameManager.sharedInstance.players[i].avatar != nil) && (GameManager.sharedInstance.players[j].avatar != nil) {
                    //print("Entrou na mudanca \(GameManager.sharedInstance.players[i].avatar!) e \(GameManager.sharedInstance.players[j].avatar!)")
                    if (GameManager.sharedInstance.players[i].avatar! == GameManager.sharedInstance.players[j].avatar!){
                        
                        //print("Entrou na mudanca 3")
                        let aux = GameManager.sharedInstance.players[j].avatar
                        GameManager.sharedInstance.players[j].avatar = nil
                        for avatar in viewController.arrayAvatars{
                            //print("Entrou na mudanca 4")
                            if avatar == aux{
                                //print("Entrou na mudanca 5")
                                viewController.arrayAvatars.removeObject(avatar)
                                //print("\(avatar) e o array: \(viewController.arrayAvatars)")
                                viewController.updateIphoneUsersData()
                                
                                switch(GameManager.sharedInstance.players[j].playerIdentifier){
                                case GameManager.sharedInstance.players[0].playerIdentifier : // player1Image.image = UIImage(named: message)
                                    char1.texture = nil
                                case GameManager.sharedInstance.players[1].playerIdentifier : // player2Image.image = UIImage(named: message)
                                    char2.texture = nil
                                case GameManager.sharedInstance.players[2].playerIdentifier : // player3Image.image = UIImage(named: message)
                                    char3.texture = nil
                                case GameManager.sharedInstance.players[3].playerIdentifier : //player4Image.image = UIImage(named: message)
                                    char4.texture = nil
                                    
                                default: break
                                }
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        setObjects()
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        popupAtlas = SKTextureAtlas(named: "popup")
        if !GlobalFlags.welcomeTutorialIpad {
            self.setTutorialScene()
        }
    }
    
    
    func setTutorialScene() {
        let strings = TutorialManager.loadStringsPlist("connectionIpad")
        var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
        tuples.append((nil, strings[0], nil))
        tuples.append((nil, strings[1], nil))
        tuples.append((nil, strings[2], nil))
        tuples.append((nil, strings[3], nil))
        tuples.append((turns, strings[4], nil))
        tuples.append((connect, strings[5], nil))
        tuples.append((nil, strings[6], nil))
        go?.userInteractionEnabled = false
        tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: false, boxScale: 1.0)
        tutorialManager.showInfo()
        GlobalFlags.welcomeTutorialIpad = true
        
    }
    
    func setObjects(){
        
        backButton = SetupPartyButton(textureOn: greenButton, textureOff: greenButtonOff)
        backButton?.delegate = self
        backButton?.name = "back"
        backButton?.zPosition = 6
        backButton?.position = CGPoint(x: backButton!.frame.width/3, y: self.frame.height/12)
        self.addChild(backButton!)
        
        back = SKLabelNode(fontNamed: "Helvetica Neue") // will be a texture probably
        back!.name = "backLabel"
        back!.text = "Back"
        //back!.position = CGPoint(x: self.frame.width/10, y: (self.frame.height)*0.85)
        back!.position.x = back!.position.x - back!.frame.width/2 + 25
        back?.fontSize = 60
        back?.zPosition = 7
        back?.fontColor = UIColor(red: 250/255, green: 52/255, blue: 67/255, alpha: 1)
        backButton?.textLabel = back
        backButton!.addChild(back!)
        
        info = SKSpriteNode(imageNamed: "infoimage")
        info!.name = "info"
        info!.position = CGPoint(x: self.frame.width/1.1, y: (self.frame.height)*0.87)
        info?.zPosition = 5
        self.addChild(info!)
        
        // set the red SETUP GAME banner
        banner = SKSpriteNode(texture: redBanner, size: redBanner.size() )
        self.addChild(banner!)
        banner!.position = CGPoint(x: self.frame.width/2, y: (self.frame.height)*0.85)
        banner?.zPosition = 4
       
        titleLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        titleLabel?.text = "Setup Party Mode"
        titleLabel?.zPosition = 5
        titleLabel!.position.y = titleLabel!.position.y - 25
        titleLabel?.fontSize = 80
        titleLabel?.fontColor = UIColor(red: 255/255, green: 242/255, blue: 202/255, alpha: 1)
        banner?.addChild(titleLabel!)
        
        // set the turn select banners
        turns = SetupPartyButton(textureOn: yellowTurnsOn, textureOff: yellowTurnsOff)
        turns?.delegate = self
        self.addChild(turns!)
        turns!.position = CGPoint(x: self.frame.width/2, y: banner!.position.y - 110)
        turns?.zPosition = 4
        
        
        // set the connect players button
        
        connect = SetupPartyButton(textureOn: yellowButton, textureOff: yellowButtonOff)
        connect!.delegate = self
        self.addChild(connect!)
        connect!.position = CGPoint(x: turns!.position.x, y: turns!.position.y - 90)
        connect?.zPosition = 4
        
        connectLabel = SKLabelNode(fontNamed: "Helvetica Neue")
        connectLabel!.text = "Connect"
        connectLabel?.fontColor = UIColor.blackColor()
        connect!.textLabel = connectLabel
        connectLabel?.zPosition = 5
        connect?.addChild(connectLabel!)
        
        // set the GO BUTTON
        go = SetupPartyButton(textureOn: greenButton, textureOff: greenButtonOff)
        go?.delegate = self
        self.addChild(go!)
        go!.position = CGPoint(x: self.frame.width - go!.frame.width/6, y: self.frame.height/12)
        go!.name = "goButton"
        go?.zPosition = 4
        
        let gotext = SKLabelNode(fontNamed: "Helvetica Neue")
        gotext.text = "GO"
        gotext.position.x = gotext.position.x - 15
        gotext.position.y = gotext.position.y - 5
        gotext.zPosition = 5
        gotext.fontSize = 60
        gotext.fontColor = UIColor(red: 250/255, green: 52/255, blue: 67/255, alpha: 1)
        go?.textLabel = gotext
        go!.addChild(gotext)
        // set the turn controll buttons

        
        numberOfTurns = SKLabelNode(fontNamed: "Helvetica Neue")
        numberOfTurns?.text = "max turns : 5"
        numberOfTurns?.fontSize = 30
        numberOfTurns?.zPosition = 5
        numberOfTurns?.fontColor = UIColor.blackColor()
        GameManager.sharedInstance.totalGameTurns = self.turnCounter
        turns!.textLabel = numberOfTurns
        turns!.addChild(numberOfTurns!)
        
        
        //setup background
        let background = SKTexture(imageNamed: "setupBG")
        let bg = SKSpriteNode(texture: background, size: background.size())
        self.addChild(bg)
        bg.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        bg.zPosition = 0
        self.backgroundColor = UIColor.whiteColor()
        
        //setup particles
        
        let globParticles = SetupParticle.fromFile("setupParticle1")
        globParticles!.position = CGPointMake(self.frame.width/2, self.frame.height + 10)
        self.addChild(globParticles!)
        globParticles?.zPosition = 1

        
        
        /*
        let spawn = SKAction.runBlock({() in self.spawnItem()})
        
        let delay = SKAction.waitForDuration(0.7, withRange: 1.4)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)*/
        
        
        //set boundary
        let boundary : SKNode = SKNode()
        boundary.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.width, height: 1))
        boundary.physicsBody?.dynamic = false
        boundary.physicsBody?.categoryBitMask = boundaryCategoryMask
        boundary.position = CGPoint(x: self.frame.width/2, y: -200)
        self.addChild(boundary)
        
        // set characters
        char1.setScale(charScale)
        char2.setScale(charScale)
        char3.setScale(charScale)
        char4.setScale(charScale)
        
        
        charInitialPosition = -(char1.size.height/2)
        
        char1.position = CGPoint(x: self.frame.width*0.2, y: charInitialPosition!)
        char1.zPosition = 6
        self.addChild(char1)
        
        /*
        let shadow1 = SKSpriteNode(imageNamed: "player1")
        shadow1.blendMode = SKBlendMode(rawValue: 0)!
        shadow1.colorBlendFactor = 1
        shadow1.color = SKColor.blackColor()
        shadow1.alpha = 0.25
        char1.addChild(shadow1)
        shadow1.zPosition = -1
        shadow1.position = CGPoint(x: 5, y: -10)
        */
    
      
        char2.position = CGPoint(x: self.frame.width * 0.4, y: charInitialPosition!)
        char2.zPosition = 6
        self.addChild(char2)
        
    /*
        let shadow2 = SKSpriteNode(imageNamed: "player2")
        shadow2.blendMode = SKBlendMode(rawValue: 0)!
        shadow2.colorBlendFactor = 1
        shadow2.color = SKColor.blackColor()
        shadow2.alpha = 0.25
        char2.addChild(shadow2)
        shadow2.zPosition = -1
        shadow2.position = CGPoint(x: 5, y: -10)
*/
        
        
        char3.position = CGPoint(x: self.frame.width*0.6, y: charInitialPosition!)
        char3.zPosition = 6
        self.addChild(char3)
        
        char4.position = CGPoint(x: self.frame.width*0.8, y: charInitialPosition!)
        char4.zPosition = 6
        self.addChild(char4)
 
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first as UITouch!
        let location: CGPoint = touch.locationInNode(self)
        
        if(backButton!.containsPoint(location)){
            viewController.dismissViewControllerAnimated(false, completion: nil)
        }
        
//        if info!.containsPoint(location){
//            self.setTutorialScene()
//        }

    }
    
    func spawnItem(){
       
        let effectsNode = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        // Set the blur amount. Adjust this to achieve the desired effect
        let blurAmount = CGFloat.random(min: 0, max: 20)
        filter!.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effectsNode.filter = filter
        effectsNode.position = self.view!.center
        effectsNode.blendMode = .Alpha
        self.addChild(effectsNode)
        
        
        let itemVal = CGFloat.random(min: 0.6, max: 3.4)
        let intItemval = Int(round(itemVal))
        let itemName = "item\(intItemval)"
        
        let texture = SKTexture(imageNamed: itemName)
        let sprite = SKSpriteNode(texture: texture)
        let diff = CGFloat.random(min: 0.5, max: 1)
        sprite.size = CGSize(width: sprite.size.width * diff, height: sprite.size.height * diff)
        effectsNode.addChild(sprite)
        
        let pos = CGFloat.random(min: 0, max: 1024)
        effectsNode.position = CGPoint(x: pos, y: self.frame.height+50)

        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height/2)
        let angle = CGFloat.random(min: 0.1, max: 0.6)
        sprite.physicsBody?.applyAngularImpulse(angle  * sprite.size.width * 0.01)
        sprite.physicsBody?.affectedByGravity = true
        sprite.zPosition = 2
        sprite.physicsBody?.categoryBitMask = fallingCategoryMask
        sprite.physicsBody?.contactTestBitMask = boundaryCategoryMask
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyA.node?.parent
            contact.bodyA.node?.removeFromParent()
            filter?.removeFromParent()
        }
        
        if contact.bodyB.categoryBitMask == fallingCategoryMask {
            let filter = contact.bodyB.node?.parent
            contact.bodyB.node?.removeFromParent()
            filter?.removeFromParent()
        }
    }
    
    func riseCharacter(char : SKSpriteNode, identifier : String){
        
        if !GlobalFlags.goTaught {
            teachHowToGo()
        }
        
        if let oldPopupNode = childNodeWithName("popup \(identifier)") {
            oldPopupNode.removeFromParent()
        }
        if let oldLabel = childNodeWithName("name \(identifier)") {
            oldLabel.removeFromParent()
        }
        
        let topHeight = (connect?.position.y)! - (connect?.size.height)!*0.25
        let charPosition = topHeight - char.size.height/2
        
        var popupTextures:[SKTexture] = []
        
        for i in 0...10 {
            popupTextures.append(popupAtlas.textureNamed("desc\(i)"))
        }
        let popupAnimation = SKAction.animateWithTextures(popupTextures, timePerFrame: 0.05)
        
        let action = SKAction.moveToY(charPosition, duration: 0.7)
        
        char.runAction(action, completion: {() in
            let popup = SKSpriteNode(texture: popupTextures.first)
            popup.name = "popup \(identifier)"
            popup.setScale(0.5)
            popup.position = CGPointMake(char.position.x, popup.size.height/2)
            self.addChild(popup)
            
            popup.zPosition = char.zPosition + 1
            popup.runAction(popupAnimation, completion: {() in
                let name = SKLabelNode(text: identifier)
                name.position = popup.position
                name.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
                name.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                name.fontName = "Helvetica Neue"
                name.name = "name \(identifier)"
                name.fontSize = 15
                self.addChild(name)
                name.zPosition = popup.zPosition + 1
            })
        })
    }
    
    func teachHowToGo() {
        checkIfCanGo()
        if canGo {
            let strings = TutorialManager.loadStringsPlist("teachGo")
            var tuples: [(node:SKNode?, text:String?, animation: SKAction?)] = []
            tuples.append((go, strings[0], nil))
            tutorialManager = TutorialManager(tuples: tuples, scene: self, isIphone: false, boxScale: 1.0)
            tutorialManager.showInfo()
        }
        GlobalFlags.goTaught = true
    }
    
    func checkIfCanGo() {
        for p in GameManager.sharedInstance.players{
            if p.avatar == nil {
                canGo = false
                break
            }else{
                canGo = true
            }
        }
    }
    
    func buttonTouched(sender: SetupPartyButton) {
        if tutorialManager != nil {
            tutorialManager.buttonActivated(sender)
        }
        
        if sender == go {
            checkIfCanGo()
            if canGo{
                self.view?.presentScene(nil)
                BoardGraph.SharedInstance.loadBoard("board_3");
                viewController.turns = turnCounter
                viewController.gotoBoardGame()
                for p in GameManager.sharedInstance.players{
                    GameManager.sharedInstance.updatePlayerMoney(p, value: p.coins)
                    GameManager.sharedInstance.activePlayer.append(p.avatar!)
                    print(p.avatar)
                }
                GameManager.sharedInstance.sendPlayersColors()
            }
        }
        
        if sender == connect {
            viewController.ConnectPlayers()
        }
        
        if sender == turns {
            turnCounter = turnCounter + 5
            if turnCounter > 30 {
                turnCounter = 5
            }
            
            numberOfTurns?.text = "max turns : \(turnCounter)"
            GameManager.sharedInstance.totalGameTurns = turnCounter
        }
        
        if sender == backButton {
            self.viewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    deinit{
        //print("SetupScene do Ipad foi retirada")
    }
}
