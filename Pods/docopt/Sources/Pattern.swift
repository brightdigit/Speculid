//
//  Pattern.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

typealias MatchResult = (match: Bool, left: [Pattern], collected: [Pattern])

internal class Pattern: Equatable, Hashable, CustomStringConvertible {
    func fix() -> Pattern {
        fixIdentities()
        fixRepeatingArguments()
        return self
    }
    var description: String {
        get {
            return "Pattern"
        }
    }
    var hashValue: Int { get {
            return self.description.hashValue
        }
    }
    
    func fixIdentities(unq: [LeafPattern]? = nil) {}
    
    func fixRepeatingArguments() -> Pattern {
        let either = Pattern.transform(self).children.map { ($0 as! Required).children }
        
        for c in either {
            for ch in c {
                let filteredChildren = c.filter {$0 == ch}
                if filteredChildren.count > 1 {
                    for child in filteredChildren {
                        let e = child as! LeafPattern
                        if ((e is Argument) && !(e is Command)) || ((e is Option) && (e as! Option).argCount != 0) {
                            if e.value == nil {
                                e.value = [String]()
                            } else if !(e.value is [String]) {
                                e.value = e.value!.description.split()
                            }
                        }
                        if (e is Command) || ((e is Option) && (e as! Option).argCount == 0) {
                            e.value = 0
                            e.valueType = .Int
                        }
                    }
                }
            }
        }
        
        return self
    }
    
    static func isInParents(child: Pattern) -> Bool {
        return (child as? Required != nil)
            || (child as? Optional != nil)
            || (child as? OptionsShortcut != nil)
            || (child as? Either != nil)
            || (child as? OneOrMore != nil)
    }
    
    static func transform(pattern: Pattern) -> Either {
        var result = [[Pattern]]()
        var groups = [[pattern]]
        while !groups.isEmpty {
            var children = groups.removeAtIndex(0)
            let child: BranchPattern? = children.filter({ self.isInParents($0) }).first as? BranchPattern
            
            if let child = child {
                let index = children.indexOf(child)!
                children.removeAtIndex(index)
                
                if child is Either {
                    for pattern in child.children {
                        groups.append([pattern] + children)
                    }
                } else if child is OneOrMore {
                    groups.append(child.children + child.children + children)
                } else {
                    groups.append(child.children + children)
                }
            } else {
                result.append(children)
            }
        }
        
        return Either(result.map {Required($0)})
    }

    func flat() -> [LeafPattern] {
        return flat(LeafPattern)
    }

    func flat<T: Pattern>(_: T.Type) -> [T] {  // abstract
        return []
    }
    
    func match<T: Pattern>(left: T, collected clld: [T]? = nil) -> MatchResult {
        return match([left], collected: clld)
    }
    
    func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {  // abstract
        return (false, [], [])
    }

    func singleMatch<T: Pattern>(left: [T]) -> SingleMatchResult {return (0, nil)} // abstract
}

func ==(lhs: Pattern, rhs: Pattern) -> Bool {
    if let lval = lhs as? BranchPattern, let rval = rhs as? BranchPattern {
        return lval == rval
    } else if let lval = lhs as? LeafPattern, let rval = rhs as? LeafPattern {
        return lval == rval
    }
    return lhs === rhs // Pattern is "abstract" and shouldn't be instantiated :)
}
