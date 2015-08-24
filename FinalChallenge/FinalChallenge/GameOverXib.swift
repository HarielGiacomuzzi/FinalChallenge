//
//  GameOverXib.swift
//  FinalChallenge
//
//  Created by bruno raupp kieling on 8/20/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit
class GameOverXib: UIViewController {
    
    @IBOutlet weak var gameOverView: UIView!
    
    override func viewDidAppear(animated: Bool) {
        gameOverView = UIView(frame: CGRectMake(100, 200, 100, 100))
    }
}