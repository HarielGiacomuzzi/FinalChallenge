//
//  IpadConnectionViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class IpadConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var connectedPlayers:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConnectionManager.sharedInstance.setupConnectionWithOptions(UIDevice.currentDevice().name, active: true);

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionChanged:", name: "ConnectionManager_ConnectionStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "ConnectionManager_DataReceived", object: nil)
    }


    // MARK: - IBActions
    
    @IBAction func startGameButtonPressed() {
    }
    

    // MARK: - UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedPlayers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("userCell") as! UITableViewCell
        
        var nameLabel = cell.viewWithTag(10) as! UILabel
        
        nameLabel.text = connectedPlayers[indexPath.row]
        
        return cell
    }
    
    func connectionChanged(data : NSNotification){
        
        let state = Int(data.userInfo!["state"] as! NSNumber)
        
        var peerID = data.userInfo!["peerID"] as! MCPeerID
        var peerDisplayName = peerID.displayName
        
        if state != 1 {
            if state == 2 {
                connectedPlayers.append(peerDisplayName)
            } else if state == 0 {
                if connectedPlayers.count > 0 {
                    connectedPlayers.removeObject(peerDisplayName)
                }
            }
            tableView.reloadData()
            
        }
        
    }
    

}
