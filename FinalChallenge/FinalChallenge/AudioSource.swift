//
//  AudioSource.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/27/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import AVFoundation
import SpriteKit

class AudioSource: NSObject, AVAudioPlayerDelegate {
    
    var soundTimer : NSTimer = NSTimer()
    var url : NSURL!
    var avPlayer : AVAudioPlayer!
    var error : NSError?
    
    //flappyFish sound effects
    var bubbleSound : SKAction!
    
    //BombGames sound effects
    var exploadSound : SKAction!
    static let sharedInstance = AudioSource()
    
    override init(){
        super.init()
    }
    //flappyFish sound effects
    func playBubbleSound() -> SKAction{
        bubbleSound = SKAction.playSoundFileNamed("bubbleSound2.wav", waitForCompletion: false)
        
        return bubbleSound
    }
    
    //bombGames sound effect
    func playExploadSound() -> SKAction{
        exploadSound = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
        return exploadSound
    }
    
    func flappyFishSound(){
        readAudioFile("funMusic", ext: "mp3", audioLoop: true)
    }
    
    func readAudioFile(fileName:String, ext:String, audioLoop:Bool){ // prepara audio
        self.url = NSBundle.mainBundle().URLForResource(fileName, withExtension: ext)
        do {
            self.avPlayer = try AVAudioPlayer(contentsOfURL: self.url)
        } catch let error1 as NSError {
            error = error1
            self.avPlayer = nil
        }
        if avPlayer == nil {
            if let e = error {
                print(e.localizedDescription)
            }
        }
        
        avPlayer.delegate = self
        avPlayer.volume = 1.0
        if audioLoop == true { // this loops the audio, like ambient audio, or music
            soundTimer = NSTimer.scheduledTimerWithTimeInterval(-1, target: self, selector: Selector("soundTimerPlayed"), userInfo: nil, repeats: true)
        } else {
            self.soundTimerPlayed()
        }
        
    }
    
    func soundTimerPlayed(){
        avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    func stopAudio(){
        avPlayer.stop()
    }
    
}
