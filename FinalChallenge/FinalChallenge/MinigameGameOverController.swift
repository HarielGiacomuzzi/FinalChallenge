//
//  MinigameGameOverController.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/24/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit


class MinigameGameOverController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var player:[String]!
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameManager.sharedInstance.minigameGameOverViewController = self
        println("Entrou no nova controller")
        //player = gameManager.playerRank
        println(player.count)
        for p in player {
            println(p)
        }
        player.reverse()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomGameOverCell
        cell.playerName.text = player[indexPath.row] as String
        return cell
    }
    
    @IBAction func buttonPressed() {
        GameManager.sharedInstance.dismissMinigame()
    }
    
}