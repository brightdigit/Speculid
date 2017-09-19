//
//  Version.swift
//  swiftver
//
//  Created by Leo Dion on 11/25/15.
//  Copyright © 2015 BrightDigit. All rights reserved.
//

import Foundation

public struct Version {
  public let semver:SemVer
  public let build:UInt8
  public let versionControl: VersionControlInfo?
  
  public struct InfoDictionaryKeys {
    public static let version = "CFBundleShortVersionString"
    public static let build = "CFBundleVersion"
  }
  
  public init?(bundle: VersionContainerProtocol, versionControl: VersionControlInfo? = nil) {
    let keys = type(of: self).InfoDictionaryKeys.self
    
    guard let versionString = bundle.infoDictionary?[keys.version] as? String else {
      return nil
    }
    
    guard let semver = SemVer(versionString: versionString) else {
      return nil
    }
    
    
    guard let buildValue = bundle.infoDictionary?[keys.build] else {
      return nil
    }
    
    let buildOpt: UInt8?
    
    if let buildInt = buildValue as? Int {
      buildOpt = UInt8(buildInt)
    } else if let buildString = buildValue as? String {
      buildOpt = UInt8(buildString)
    } else {
      return nil
    }
    
    guard let build = buildOpt else {
      return nil
    }
    
    self.build = build
    self.semver = semver
    self.versionControl = versionControl
  }
}
