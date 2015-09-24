//
//  MinigameGameOverController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/24/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

// THIS CLASS IS NOT USED ANYMORE, CAN BE DELETED...OR MAY BE USED LATER, DON`T KNOW

class MinigameGameOverController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var player:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.sharedInstance.minigameGameOverViewController = self
        //player = gameManager.playerRank
        print(player.count)
        for p in player {
            print(p)
        }
        //Array(player.reverse())
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomGameOverCell
        cell.playerName.text = player[indexPath.row] as String
        return cell
    }
    
    @IBAction func buttonPressed() {
        GameManager.sharedInstance.dismissMinigame()
    }
    
}