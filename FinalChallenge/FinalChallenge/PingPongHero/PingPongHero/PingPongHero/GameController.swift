//
//  GameController.swift
//  PingPongHero
//
//  Created by bruno raupp kieling on 7/20/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import CoreMotion

class GameController: UIViewController {
    
    var tableAudioPlayer = AVAudioPlayer()
    var raquetAudioPlayer = AVAudioPlayer()
    var timer1 = NSTimer()
    var timer2 = NSTimer()
    var queue = NSOperationQueue()
    lazy var motionManager = CMMotionManager()
    var canHit = false
    var playerTurn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canHit = true
        setupSound()
        monitorUserMovements()

    }
    
    
    func monitorUserMovements() {
        var forceArray:[Double] = []
        var isHitting = false
        var didHit = false
        motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler:
            {data, error in
                if data.userAcceleration.z < -0.5 && data.gravity.x < 0 {
                    isHitting = true
                    forceArray.append(data.userAcceleration.z)
                } else {
                    if isHitting {
                        isHitting = false
                        dispatch_async(dispatch_get_main_queue()) {
                            self.playerDidTryToHit(forceArray)
                        }
                        self.motionManager.stopDeviceMotionUpdates()

                    }

                }
                
        })
    }
    
    func ballDidHitTable() {
        println("balldidhittable")
        tableAudioPlayer.play()
        if playerTurn {
            timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("vibrate"), userInfo: nil, repeats: false)
        } else {
            timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("enemyPlayerResponded"), userInfo: nil, repeats: false)
        }
        //play sound
        //setup timer
    }
    
    func vibrate() {
        println("vibrate")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        canHit = true
    }
    
    func playerDidTryToHit(force:[Double]) {
        println("playerdidtrytohit")
        println(force)
        playerDidHit()

    }
    
    func playerDidHit() {
        println("playerdidhit")
        raquetAudioPlayer.play()
        //setup timer for ball hitting table
        timer1 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("ballDidHitTable"), userInfo: nil, repeats: false)
        playerTurn = false
    }
    
    func playerDidMiss() {
        
    }
    
    func enemyPlayerResponded() {
        println("enemyresponded")
        raquetAudioPlayer.play()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("ballDidHitTable"), userInfo: nil, repeats: false)
        playerTurn = true
        monitorUserMovements()
        //if hit blablabla
        //if miss blablabla
    }
    
    func setupSound() {
        var raquetSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("raquetsound", ofType: "wav")!)
        var tableSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tablesound", ofType: "wav")!)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        tableAudioPlayer = AVAudioPlayer(contentsOfURL: tableSound, error: &error)
        raquetAudioPlayer = AVAudioPlayer(contentsOfURL: raquetSound, error: &error)

    }
}