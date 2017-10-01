//
//  ArrayError.swift
//  speculid
//
//  Created by Leo Dion on 9/27/16.
//
//

import Foundation

public struct ArrayError : Error {
  public let errors : [Error]
  
  public static func error (for errors: [Error]) -> Error? {
    if errors.count > 1 {
      return ArrayError(errors: errors)
    } else {
      return errors.first
    }
  }
}
