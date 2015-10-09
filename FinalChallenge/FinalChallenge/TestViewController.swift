//
//  TestViewController.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 10/8/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = TestScene(size: CGSize(width: 1024, height: 768))
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        scene.scaleMode = .Fill
        print("abriu?")
    
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
