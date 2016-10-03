//
//  ImageConversionTaskProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/25/16.
//
//

import Foundation

public protocol ImageConversionTaskProtocol {
  func start (callback : @escaping (Error?) -> Void)
}
