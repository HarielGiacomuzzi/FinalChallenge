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
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}