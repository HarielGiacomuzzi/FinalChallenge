//
//  AlertPath.swift
//  FinalChallenge
//
//  Created by Cristiane on 03/09/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import UIKit

class AlertPath: UIAlertController{
    
    var quantity = 0
    var node : BoardNode?
    var lista : [BoardNode]?
    var viewToShow : UIViewController?
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        GameManager.sharedInstance.hasPath = false;
        GameManager.sharedInstance.pathChosen()
    }

}