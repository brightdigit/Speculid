//
//  ApplicationPathDataSource.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

@available(*, deprecated: 2.0.0)
public protocol ApplicationPathDataSource {
  func applicationPaths (_ closure: @escaping (ApplicationPathDictionary) -> Void)
}
