//
//  ConnectionManager.swift
//  PingPongHero
//
//  Created by Hariel Giacomuzzi on 7/22/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager: NSObject, MCSessionDelegate{
    var peerID: MCPeerID = MCPeerID();
    var session: MCSession!
    var browser: MCBrowserViewController?;
    private var isIpad = false;
    private var iPadPeer : MCPeerID?
    var advertiser: MCAdvertiserAssistant = MCAdvertiserAssistant();
    let ServiceID = "iFiesta";
    static let sharedInstance = ConnectionManager();
    
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
        session = MCSession(peer: peerID)
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
            self.session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: error);
        }
        
            self.session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable, error: error);
        })
        return true
    }
    
    private func getIpadPeer(){
        if self.iPadPeer == nil{
            var aux = ["whoIs" : "iPad"];
            self.sendDictionaryToPeer(aux, reliable: true);
        }
    }
    
    //sends a String to the other peer
    private func getStreamToIpad() -> NSOutputStream{
            let error = NSErrorPointer();
            if self.iPadPeer == nil{
                self.getIpadPeer();
            }
            return self.session.startStreamWithName("ControlTestStream", toPeer: self.iPadPeer, error: error);
    }
    
    //sends a NSDictionary to the other peer
    func sendDictionaryToPeer(message : NSDictionary?, reliable : Bool) -> Bool{
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let error = NSErrorPointer();
        if (reliable){
            self.session.sendData(NSKeyedArchiver.archivedDataWithRootObject(message!), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: error);
            return
        }
        
            self.session.sendData(NSKeyedArchiver.archivedDataWithRootObject(message!), toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable, error: error);
        })
        return true
    }
    
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        certificateHandler(true)
        })
    }
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let userInfo = ["peerID":peerID, "state":state.rawValue]
            NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_ConnectionStatusChanged", object: nil, userInfo: userInfo)
        })
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
        var userInfo = ["data":data, "peerID":peerID.displayName!]
            
        // If is someone's turn
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary{
                if message.valueForKey("playerTurn") != nil && message.valueForKey("playerID") as! String  ==  ConnectionManager.sharedInstance.peerID.displayName {
                     NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_PlayerTurn", object: nil, userInfo: nil)
                    return
            }
        }
        // if we received the dice results of a player
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary{
            if message.valueForKey("diceResult") != nil {
                userInfo.updateValue(message.valueForKey("diceResult") as! Int, forKey: "diceResult")
                GameManager.sharedInstance.messageReceived(userInfo)
                //NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_DiceResult", object: nil, userInfo: userInfo)
                return
            }
        }
        
        // if there's a whoIs request
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary{
            if message.valueForKey("whoIs") != nil && message.valueForKey("whoIs") as! String  ==  "iPad" {
                if self.isIpad{
                    var response = ["peer" : self.peerID, "whoIs" : "response", "peerRequested" : "iPad"]
                    self.sendDictionaryToPeer(response, reliable: true);
                }
                return
            }
        }
            
        // if there's a whoIs request
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary{
            if message.valueForKey("whoIs") != nil && message.valueForKey("whoIs") as! String  ==  "response" {
                if message.valueForKey("peerRequested") as! String == "iPad"{
                    if self.iPadPeer == nil {
                        self.iPadPeer = message.valueForKey("peer") as? MCPeerID;
                    }
                }
                return
            }
        }
            
        // if we receive the commad of a controller
        if let message = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? NSDictionary{
            if message.valueForKey("controllerAction") != nil {
                userInfo.updateValue(message.valueForKey("action") as! NSObject, forKey: "actionReceived")
                NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_ControlAction", object: nil, userInfo: userInfo)
                return
            }
        }
            
            
        // if I dont know what it is I will send the default message
        NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_DataReceived", object: nil, userInfo: userInfo)
            
        })
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!){
    
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!){
    
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!){
    
    }
    
}