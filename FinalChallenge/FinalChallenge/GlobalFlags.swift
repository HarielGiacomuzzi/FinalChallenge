//
//  GlobalFlags.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/30/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class GlobalFlags: NSObject {
    
    // Mark :- Game Setup Ipad
    
    static var welcomeTutorialIpad: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("welcomeTutorialIpad")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "welcomeTutorialIpad")
        }
    }
    
    static var goTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("goTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "goTaught")
        }
    }
    
    // Mark :- Game Setup Iphone
    
    static var welcomeTutorialIphone: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("welcomeTutorialIphone")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "welcomeTutorialIphone")
        }
    }
    
    static var chooseCharTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("chooseCharTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "chooseCharTaught")
        }
    }
    
    // Mark :- Board
    
    static var boardTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("boardTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "boardTaught")
        }
    }
    
    // Mark :- Player View Scene
    
    static var diceTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("diceTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "diceTaught")
        }
    }
    
    static var cardTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("cardTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "cardTaught")
        }
    }
    
    static var gameTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("gameTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "gameTaught")
        }
    }
    
    // Mark :- Store
    
    static var storeTaught: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey("storeTaught")
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: "storeTaught")
        }
    }

}
