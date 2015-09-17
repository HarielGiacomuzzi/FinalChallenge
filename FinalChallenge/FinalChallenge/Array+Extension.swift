//
//  ArrayExtension.swift
//  CardioGuide
//
//  Created by Daniel Amarante on 6/26/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
    
    //gets random item and removes from array
    mutating func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        var item = self[index]
        self.removeAtIndex(index)
        return item
    }
    

}