//
//  NoAnimationSegue.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/4/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit

class NoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        sourceViewController.presentViewController(destinationViewController , animated: false, completion: nil)
    }
}
