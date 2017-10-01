//
//  VersionControlInfo.swift
//  SwiftVer
//
//  Created by Leo Dion on 9/21/16.
//  Copyright © 2016 BrightDigit, LLC. All rights reserved.
//

import Foundation

public struct VersionControlInfo {
  public let TYPE:VersionControlType
  public let BASENAME:String
  public let UUID:	String?
  public let NUM:	Int
  public let DATE: Date?
  public let BRANCH:	String
  public let TAG:	String?
  public let TICK:	Int?
  public let EXTRA:	String?
  
  public let FULL_HASH:		String
  public let SHORT_HASH:		String
  
  public let WC_MODIFIED:	Bool
  
  public init (TYPE:String
    ,BASENAME:String
    ,UUID: String?
    ,NUM:  Int
    ,DATE: String
    ,BRANCH: String
    ,TAG:  String?
    ,TICK: Int?
    ,EXTRA:  String?
    
    ,FULL_HASH:    String
    ,SHORT_HASH:   String
    
    ,WC_MODIFIED:  Bool) {
    self.TYPE = VersionControlType(TYPE: TYPE)
    self.BASENAME = BASENAME
    self.UUID = UUID
    self.NUM = NUM
    self.DATE = date(forRFC3339DateTimeString: DATE)
    self.BRANCH = BRANCH
    self.TAG = TAG
    self.TICK = TICK
    self.EXTRA = EXTRA
    self.FULL_HASH = FULL_HASH
    self.SHORT_HASH = SHORT_HASH
    self.WC_MODIFIED = WC_MODIFIED
  }
}
