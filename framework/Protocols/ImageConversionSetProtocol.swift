//
//  ImageConversionSetProtocol.swift
//  Speculid
//
//  Created by Leo Dion on 9/30/17.
//

import Foundation

public protocol ImageConversionSetProtocol {
  func run (_ callback : @escaping (Error?) -> Void)
}