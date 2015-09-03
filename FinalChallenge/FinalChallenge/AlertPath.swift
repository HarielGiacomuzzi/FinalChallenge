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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        GameManager.sharedInstance.pathChosen()
    }

}