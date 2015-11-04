//
//  String+Extension.swift
//  FinalChallenge
//
//  Created by Daniel Amarante on 11/3/15.
//  Copyright © 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation

extension String {
    func separateInCharacter(index:Int) -> [String] {
        let array = self.componentsSeparatedByString(" ")
        var counter = 0
        var finalString1 = ""
        var finalString2 = ""
        for string in array {
            counter += string.characters.count
            if counter < index {
                finalString1 += string + " "
            } else {
                finalString2 += string + " "
            }
            
        }
        return [finalString1, finalString2]
    }
}