//
//  Argument.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Argument: LeafPattern {
    override internal var description: String {
        get {
            return "Argument(\(name), \(value))"
        }
    }
    
    override func singleMatch<T: LeafPattern>(left: [T]) -> SingleMatchResult {
        for i in 0..<left.count {
            let pattern = left[i]
            if pattern is Argument {
                return (i, Argument(self.name, value: pattern.value))
            }
        }
        return (0, nil)
    }
}