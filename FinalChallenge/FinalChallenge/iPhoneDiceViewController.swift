//
//  iPhoneDiceViewController.swift
//  FinalChallenge
//
//  Created by Hariel Giacomuzzi on 8/25/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

class iPhoneDiceViewController: UIViewController {
    var diceResult = 0;
    @IBOutlet weak var lblResult: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @IBAction func rollDice(sender: AnyObject) {
        diceResult = Int(arc4random_uniform(6)+1);
        lblResult.text = diceResult.description;
        sendResults();
    }
    
    func sendResults(){
        let aux = NSMutableDictionary();
        aux.setValue(diceResult, forKey: "diceResult");
        aux.setValue(ConnectionManager.sharedInstance.peerID!.displayName, forKey: "playerID");
        ConnectionManager.sharedInstance.sendDictionaryToPeer(aux, reliable: true);
        print("mandei")
        self.navigationController?.popViewControllerAnimated(true);
    }
}