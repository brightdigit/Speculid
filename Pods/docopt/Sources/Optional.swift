//
//  Optional.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Optional: BranchPattern {
    override var description: String {
        get {
            return "Optional(\(children))"
        }
    }
    
    override func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {
        var collected: [Pattern] = clld ?? []
        var l: [Pattern] = left
        for pattern in children {
            (_, l, collected) = pattern.match(l, collected: collected)
        }
        
        return (true, l, collected)
    }
}