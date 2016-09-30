//
//  Speculid.swift
//  speculid
//
//  Created by Leo Dion on 9/29/16.
//
//

import Foundation
import SwiftVer

public struct Speculid {
  private class _VersionHandler {
    
  }
  
  public static let version = Version(bundle: Bundle(for: _VersionHandler.self))
}
