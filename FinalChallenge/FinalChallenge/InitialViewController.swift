//
//  InitialViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 8/13/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    let idiom = UI_USER_INTERFACE_IDIOM()
    let iPad = UIUserInterfaceIdiom.Pad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func partyModeButton() {
        
        if idiom == iPad {
            performSegueWithIdentifier("ipadSegue", sender: nil)
        } else {
            performSegueWithIdentifier("iphoneSegue", sender: nil)
        }
        
    }


}
