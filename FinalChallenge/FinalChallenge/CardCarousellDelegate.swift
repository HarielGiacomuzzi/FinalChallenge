//
//  CardCarousellProtocol.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 9/21/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import SpriteKit

protocol CardCarousellDelegate : class {
    func sendCard(card:SKSpriteNode)
}