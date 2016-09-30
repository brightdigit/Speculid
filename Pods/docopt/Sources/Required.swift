//
//  Required.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Required: BranchPattern {
    override var description: String {
        get {
            return "Required(\(children))"
        }
    }

    override func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {
        let collected: [Pattern] = clld ?? []
        var l: [Pattern] = left
        var c = collected
        for pattern in children {
            var m: Bool
            (m, l, c) = pattern.match(l, collected: c)
            if !m {
                return (false, left, collected)
            }
        }
        
        return (true, l, c)
    }
}
