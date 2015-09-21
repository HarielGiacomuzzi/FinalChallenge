//
//  ConnectionManager.swift
//  PingPongHero
//
//  Created by Hariel Giacomuzzi on 7/22/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager: NSObject, MCSessionDelegate, NSStreamDelegate{
    var peerID: MCPeerID?
    var session: MCSession!
    var browser: MCBrowserViewController?;
    private var isIpad = false;
    private var iPadPeer : MCPeerID?
    var advertiser : MCAdvertiserAssistant!
    let ServiceID = "iFiesta";
    static let sharedInstance = ConnectionManager();
    
    override init() {
        super.init();
    }
    
    func setupConnectionWithOptions(displayName : String, active : Bool){
        setupPeerWithDisplayName(displayName);
        setupSession();
        advertiseSelf(active);
    }
    
    func setupPeerWithDisplayName (displayName:String){
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            self.isIpad = true;
        }
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerID!)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: self.ServiceID, session: session)
    }
    
    func closeConections(){
        session.disconnect();
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise{
            advertiser = MCAdvertiserAssistant(serviceType: self.ServiceID, discoveryInfo: nil, session: session)
            advertiser.start()
        }else{
            advertiser.stop()
            advertiser = MCAdvertiserAssistant();
        }
        
    }
    
    //sends a String to the other peer
    func sendStringToPeer(message : String, reliable : Bool) -> Bool{
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let error = NSErrorPointer();
        if (reliable){
            do {
                try self.session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            } catch var error1 as NSError {
                error.memory = error1
            } catch {
                fatalError()
            };
        }
        
        do {
            try self.session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
        } catch var error1 as NSError {
            error.memory = error1
        } catch {
            fatalError()
        };
        })
        return true
    }
    
    func getIpadPeer() -> MCPeerID?{
        if self.iPadPeer == nil{
            let aux = ["whoIs" : "iPad"];
            self.sendDictionaryToPeer(aux, reliable: true);
            return nil
        }
        return self.iPadPeer;
    }
    
    //sends a stream to the iPad
    func getStreamToIpad(streamName : String)-> NSOutputStream?{
            let error = NSErrorPointer();
            if self.iPadPeer == nil{
                self.getIpadPeer();
                return nil;
            }
            do {
                return try self.session.startStreamWithName(streamName, toPeer: self.iPadPeer!)
            } catch _ {
                return nil
            };
    }
    
    //sends a NSDictionary to the other peer
    func sendDictionaryToPeer(message : NSDictionary?, reliable : Bool) -> Bool{
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let error = NSErrorPointer();
        if (reliable){
            do {
                try self.session.sendData(NSKeyedArchiver.archivedDataWithRootObject(message!), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            } catch {
                fatalError()
            };
            return
        }
        
        do {
            try self.session.sendData(NSKeyedArchiver.archivedDataWithRootObject(message!), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
        } catch let error1 as NSError {
            error.memory = error1
        } catch {
            fatalError()
        };
        })
        return true
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: ((Bool) -> Void)) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        certificateHandler(true)
        })
    }
    
    // Remote peer changed state
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let userInfo = ["peerID":peerID, "state":state.rawValue]
        
        if state == MCSessionState.NotConnected{
            //println("Peer \(peerID.displayName) Disconnected");
            NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_PeerDisconnected", object: nil, userInfo: userInfo)
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_ConnectionStatusChanged", object: nil, userInfo: userInfo)
        })
    }
    
    // Received data from remote peer
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
        var userInfo = ["data":data, "peerID":peerID.displayName]
            if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary{
        // If is someone's turn
                if message.valueForKey("playerTurn") != nil && message.valueForKey("playerID") as! String  ==  ConnectionManager.sharedInstance.peerID!.displayName {
                     NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_PlayerTurn", object: nil, userInfo: nil)
                    return
            }
        // if we received the dice results of a player
            if message.valueForKey("diceResult") != nil {
                userInfo.updateValue(message.valueForKey("diceResult") as! Int, forKey: "diceResult")
                GameManager.sharedInstance.messageReceived(userInfo)
                return
            }
                // if someone have been disconnected
            if message.valueForKey("Disconnected") != nil {
                userInfo.updateValue(message.valueForKey("Disconnected") as! String, forKey: "peer")
                //println("peer Disconnected")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_PeerDisconnected", object: nil, userInfo: userInfo)
                return
            }
                
        // if there's a whoIs request
            if message.valueForKey("whoIs") != nil && message.valueForKey("whoIs") as! String  ==  "iPad" {
                if self.isIpad{
                    let response = ["peer" : self.peerID!, "whoIs" : "response", "peerRequested" : "iPad"]
                    self.sendDictionaryToPeer(response, reliable: true);
                }
                return
            }
            
        // if there's a whoIs request response
            if message.valueForKey("whoIs") != nil && message.valueForKey("whoIs") as! String  ==  "response" {
                if message.valueForKey("peerRequested") as! String == "iPad"{
                    if self.iPadPeer == nil {
                        self.iPadPeer = message.valueForKey("peer") as? MCPeerID;
                    }
                }
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_WhoIsResponse", object: nil, userInfo: nil)
                return
            }
            
        // if we receive the commad of a controller
            if message.valueForKey("PuffGamePad") != nil {
                userInfo.updateValue(message.valueForKey("action") as! NSObject, forKey: "actionReceived")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_PuffGamePadAction", object: nil, userInfo: userInfo)
                return
            }
            
        // if we receive the commad of a controller
            if message.valueForKey("controllerAction") != nil {
                userInfo.updateValue(message.valueForKey("action") as! NSObject, forKey: "actionReceived")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_ControlAction", object: nil, userInfo: userInfo)
                return
            }
            
        // if it's time to open gamepad
            if message.valueForKey("openController") != nil {
                userInfo.updateValue(message.valueForKey("gameName") as! NSObject, forKey: "gameName")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_OpenController", object: nil, userInfo: userInfo)
                return
            }
            
        // if it's time to open gamepad
            if message.valueForKey("closeController") != nil {
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_CloseController", object: nil, userInfo: userInfo)
                return
                }
        // send avatar to iPad controller
            if message.valueForKey("GameSetup") != nil {
                userInfo.updateValue(message.valueForKey("avatar") as! NSObject, forKey: "avatar")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_GameSetup", object: nil, userInfo: userInfo)
                return
            }
            
        //
            if message.valueForKey("IphoneGameSetup") != nil {
                userInfo.updateValue(message.valueForKey("arrayPlayers") as! NSObject, forKey: "arrayPlayers")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_IphoneGameSetup", object: nil, userInfo: userInfo)
                return
            }
        // change iphoneview
                
            if message.valueForKey("IphoneChangeView") != nil {
                userInfo.updateValue(message.valueForKey("change") as! NSObject, forKey: "change")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_IphoneChangeView", object: nil, userInfo: userInfo)
                return
            }
        // update player money
            if message.valueForKey("updateMoney") != nil {
                print(message)
                userInfo.updateValue(message.valueForKey("dataDic") as! NSObject, forKey: "dataDic")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_UpdateMoney", object: nil, userInfo: userInfo)
                return
            }
        }
        // if I dont know what it is I will send the default message
        NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_DataReceived", object: nil, userInfo: userInfo)
            
        })
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            stream.delegate = self;
            stream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode);
            stream.open();
        })
    }
    
    //manages the stream incomming messages
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent){
        if (eventCode == NSStreamEvent.HasBytesAvailable) {
            let stream = aStream as! NSInputStream
            var buffer = [UInt8](count: 8, repeatedValue: 0)
            // Read a single byte
            if stream.hasBytesAvailable {
                let result: Int = stream.read(&buffer, maxLength: buffer.count)
                print("received: \(result)")
            }
        } else if (eventCode == NSStreamEvent.EndEncountered) {
            // notify application that stream has ended
        } else if (eventCode == NSStreamEvent.ErrorOccurred) {
            // notify application that stream has encountered and error
        }
    
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress){
    
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){
    
    }
    
}