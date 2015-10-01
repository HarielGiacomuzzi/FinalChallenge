//
//  GamePadScene.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/1/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class GamePadScene: SKScene {
    
    weak var viewController : iPhonePlayerViewController?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeController:", name: "ConnectionManager_CloseController", object: nil);
    }
    
    
    func closeController(data:NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        viewController?.loadPlayerView()
        
    }
}
