//
//  SpeculidConfigurationLoaderProtocol.swift
//  speculid
//
//  Created by Leo Dion on 10/17/16.
//
//

import Foundation

public protocol SpeculidConfigurationLoaderProtocol {
  func load (_ closure: @escaping (SpeculidConfigurationProtocol) -> Void)
}
