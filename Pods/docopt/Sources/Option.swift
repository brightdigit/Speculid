//
//  Option.swift
//  docopt
//
//  Created by Pavel S. Mazurin on 2/28/15.
//  Copyright (c) 2015 kovpas. All rights reserved.
//

import Foundation

internal class Option: LeafPattern {
    internal var short: String?
    internal var long: String?
    internal var argCount: UInt
    override internal var name: String? {
        get {
            return self.long ?? self.short
        }
        set {
        }
    }
    override var description: String {
        get {
            return "Option(\(short), \(long), \(argCount), \(value))"
        }
    }
    
    convenience init(_ option: Option) {
        self.init(option.short, long: option.long, argCount: option.argCount, value: option.value)
    }
    
    init(_ short: String? = nil, long: String? = nil, argCount: UInt = 0, value: AnyObject? = false) {
        assert(argCount <= 1)
        self.short = short
        self.long = long
        self.argCount = argCount

        super.init("", value: value)
        if argCount > 0 && value as? Bool == false {
            self.value = nil
        } else {
            self.value = value
        }
    }
    
    static func parse(optionDescription: String) -> Option {
        var short: String? = nil
        var long: String? = nil
        var argCount: UInt = 0
        var value: AnyObject? = false
        
        var (options, _, description) = optionDescription.strip().partition("  ")
        options = options.stringByReplacingOccurrencesOfString(",", withString: " ", options: [], range: nil)
        options = options.stringByReplacingOccurrencesOfString("=", withString: " ", options: [], range: nil)
        
        for s in options.componentsSeparatedByString(" ").filter({!$0.isEmpty}) {
            if s.hasPrefix("--") {
                long = s
            } else if s.hasPrefix("-") {
                short = s
            } else {
                argCount = 1
            }
        }
        
        if argCount == 1 {
            let matched = description.findAll("\\[default: (.*)\\]", flags: .CaseInsensitive)
            value = matched.count > 0 ? matched[0] : nil
        }
        
        return Option(short, long: long, argCount: argCount, value: value)
    }
    
    override func singleMatch<T: LeafPattern>(left: [T]) -> SingleMatchResult {
        for i in 0..<left.count {
            let pattern = left[i]
            if pattern.name == name {
                return (i, pattern)
            }
        }
        return (0, nil)
    }
}

func ==(lhs: Option, rhs: Option) -> Bool {
    let valEqual = lhs as LeafPattern == rhs as LeafPattern
    return lhs.short == rhs.short
        && lhs.long == lhs.long
        && lhs.argCount == rhs.argCount
        && valEqual
}
