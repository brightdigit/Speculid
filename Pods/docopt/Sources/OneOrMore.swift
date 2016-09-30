//
//  OneOrMore.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class OneOrMore: BranchPattern {
    override var description: String {
        get {
            return "OneOrMore(\(children))"
        }
    }
    
    override func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {
        assert(children.count == 1)
        let collected: [Pattern] = clld ?? []
        var l: [Pattern] = left
        var c = collected
        var l_: [Pattern]? = nil
        var matched = true
        var times = 0
        while matched {
            // could it be that something didn't match but changed l or c?
            (matched, l, c) = self.children[0].match(l, collected: c)
            times += matched ? 1 : 0
            if l_ != nil && l_! == l {
                break
            }
            l_ = l
        }
        
        if times >= 1 {
            return (true, l, c)
        }
        
        return (false, left, collected)
    }
}
