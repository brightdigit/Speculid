//
//  Either.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Either : BranchPattern {
    override var description: String {
        get {
            return "Either(\(children))"
        }
    }

    override func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {
        let collected: [T] = clld ?? []
        var outcomes: [MatchResult] = []
        
        for pattern in children {
            let outcome = pattern.match(left, collected: collected)
            if outcome.match {
                outcomes.append(outcome)
            }
        }
        if !outcomes.isEmpty {
            return outcomes.sort({$0.left.count < $1.left.count})[0]
        }
        
        return (false, left, collected)
    }
}