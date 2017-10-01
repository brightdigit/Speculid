//
//  VersionContainerProtocol.swift
//  SwiftVer
//
//  Created by Leo Dion on 9/21/16.
//  Copyright © 2016 BrightDigit, LLC. All rights reserved.
//

import Foundation

public protocol VersionContainerProtocol {
  var infoDictionary : [String : Any]? { get }
}

extension Bundle : VersionContainerProtocol {
  
}
