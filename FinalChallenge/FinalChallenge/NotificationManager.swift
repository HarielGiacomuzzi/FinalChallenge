//
//  NotificationManager.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 11/4/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class NotificationManager: NSObject, InformationNodeDelegate {
    var notifications: [String] = []
    weak var scene: SKScene!
    var infoBox: InformationBoxNode!
    var boxScale: CGFloat = 2.0
    var isActive = false
    
    init(notifications: [String], scene: SKScene) {
        super.init()
                print("init notificationmanager")
        self.notifications = notifications
        self.scene = scene
    }
    
    func showInfo() {
        if let text = notifications.first {
            isActive = true
            setupText(text)
        } else {
            isActive = false
        }
    }
    
    func closeInformation() {
        if infoBox != nil {
            infoBox.removeFromParent()
        }
        if !notifications.isEmpty {
            notifications.removeFirst()
        }
        showInfo()
    }
    
    func setupText(text:String) {
        infoBox = InformationBoxNode(isIphone: true, text: text)
        infoBox.delegate = self
        
        infoBox.setScale(boxScale)
        
        infoBox.position = CGPointMake(scene.frame.size.width/2, infoBox.calculateAccumulatedFrame().height/2)
        
        infoBox.zPosition = 500
        if scene != nil {
            scene.addChild(infoBox)
        }
    }
    
    static func loadStringsPlist(name: String, replaceable: String) -> String? {
        
        let path = NSBundle.mainBundle().pathForResource("AlertMessages", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let string = dict![name] as? String
        let newString = string?.stringByReplacingOccurrencesOfString("$", withString: replaceable)
        
        if newString != nil {
            return newString
        } else {
            return name
        }

    }
}
