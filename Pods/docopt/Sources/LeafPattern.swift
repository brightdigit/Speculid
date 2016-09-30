//
//  LeafPattern.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 3/1/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

typealias SingleMatchResult = (position: Int, match: Pattern?)

enum ValueType {
    case Nil, Bool, Int, List, String
}

internal class LeafPattern : Pattern {
    var name: String?
    var value: AnyObject? {
        willSet {
            switch newValue {
            case is Bool:
                valueType = valueType != .Int ? .Bool : valueType
            case is [String]:
                valueType = .List
            case is String:
                valueType = .String
            case is Int:
                valueType = .Int // never happens. Set manually when explicitly set value to int :(
            default:
                valueType = .Nil
            }
        }
    }
    var valueType: ValueType = .Nil
    override var description: String {
        get {
            switch valueType {
            case .Bool: return "LeafPattern(\(name), \(value as! Bool))"
            case .List: return "LeafPattern(\(name), \(value as! [String]))"
            case .String: return "LeafPattern(\(name), \(value as! String))"
            case .Int: return "LeafPattern(\(name), \(value as! Int))"
            case .Nil: fallthrough
            default: return "LeafPattern(\(name), \(value))"
            }
            
        }
    }
    
    init(_ name: String?, value: AnyObject? = nil) {
        self.name = name
        self.value = value
    }
    
    override func flat<T: LeafPattern>(_: T.Type) -> [T] {
        if let cast = self as? T {
            return [cast]
        }
        return []
    }
    
    override func match<T: Pattern>(left: [T], collected clld: [T]? = nil) -> MatchResult {
        let collected: [Pattern] = clld ?? []
        let (pos, mtch) = singleMatch(left)
        
        if mtch == nil {
            return (false, left, collected)
        }
        let match = mtch as! LeafPattern
        
        var left_ = left
        left_.removeAtIndex(pos)
        
        var sameName = collected.filter({ item in
            if let cast = item as? LeafPattern {
                return self.name == cast.name
            }
            return false
        }) as! [LeafPattern]
        
        if (valueType == .Int) || (valueType == .List) {
            var increment: AnyObject? = 1
            if valueType != .Int {
                increment = match.value
                if let val = match.value as? String {
                    increment = [val]
                }
            }
            if sameName.isEmpty {
                match.value = increment
                match.valueType = valueType
                return (true, left_, collected + [match])
            }
            if let inc = increment as? Int {
                sameName[0].value = sameName[0].value as! Int + inc
                sameName[0].valueType = .Int
            } else if let inc = increment as? [String] {
                sameName[0].value = ((sameName[0].value as? [String]) ?? [String]()) + inc
            }
            return (true, left_, collected)
        }
        
        return (true, left_, collected + [match])
    }
}

func ==(lhs: LeafPattern, rhs: LeafPattern) -> Bool {
    let valEqual: Bool
    if let lval = lhs.value as? String, let rval = rhs.value as? String {
        valEqual = lval == rval
    } else if let lval = lhs.value as? Bool, let rval = rhs.value as? Bool {
        valEqual = lval == rval
    } else if let lval = lhs.value as? [String], let rval = rhs.value as? [String] {
        valEqual = lval == rval
    } else {
        valEqual = lhs.value === rhs.value
    }
    return lhs.name == rhs.name && valEqual
}
