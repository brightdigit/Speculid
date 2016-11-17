//
//  ApplicationPathDataSource.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol ApplicationPathDataSource {
  func applicationPaths (_ closure: @escaping (ApplicationPathDictionary) -> Void)
}
