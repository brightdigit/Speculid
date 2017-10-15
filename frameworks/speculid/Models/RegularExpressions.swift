//
//  RegularExpressions.swift
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/14/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation

public enum RegularExpressionKey {
  
}

public typealias RegularExpressionParameters = (String, NSRegularExpression.Options)

public struct RegularExpressions {
  public let dictionary : [RegularExpressionKey : NSRegularExpression]

  public init (dictionary : [RegularExpressionKey : RegularExpressionParameters]) {
    
  }
}


