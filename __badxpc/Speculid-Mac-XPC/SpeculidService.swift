//
//  SpeculidService.swift
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/9/17.
//

import Cocoa

@objc public class SpeculidService : NSObject, SpeculidServiceProtocol {
  
  public override init() {
    super.init()
  }
  public func upperCaseString(_ aString: String!, withReply reply: ((String?) -> Void)!) {
    reply(aString.uppercased())
  }
}
