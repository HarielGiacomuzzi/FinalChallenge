//
//  CreateRoomController.swift
//  PingPongHero
//
//  Created by bruno raupp kieling on 7/21/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class CreateRoomController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameArray.append("Multiplayer")
        gameArray.append("Singleplayer")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCellGameMode
        
        cell.mode.text = gameArray[indexPath.row]
        
        return cell
    }
    
}