//
//  ErrorCollection.swift
//  Speculid
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Cocoa

public class ErrorCollection : NSError {
  public let errors : [NSError]
  
  public init?(errors : [NSError]) {
    guard errors.count > 0 else {
      return nil
    }
    self.errors = errors
    super.init(domain: Bundle(for: type(of: self)).bundleIdentifier!, code: 800, userInfo: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    guard let errors = aDecoder.decodeObject(forKey: "errors") as? [NSError] else {
      return nil
    }
    self.errors = errors
    super.init(coder: aDecoder)
  }
  
  public override func encode(with aCoder: NSCoder) {
    super.encode(with: aCoder)
    aCoder.encode(self.errors, forKey: "errors")
  }
}
