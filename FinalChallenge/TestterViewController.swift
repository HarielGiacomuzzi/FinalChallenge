//
//  TestterViewController.swift
//  FinalChallenge
//
//  Created by Jonathas Hernandes on 15/10/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import SpriteKit


class TestterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let scene = GameOverSceneMP(size: CGSize(width: 1024, height: 768))
        
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)
        print("apresentei a cena sem crashar")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
