//
//  UnknownConversionError.swift
//  Speculid
//
//  Created by Leo Dion on 9/30/17.
//

import Foundation

public struct UnknownConversionError : Error {
  let document : SpeculidDocumentProtocol
  
  public init (fromDocument document: SpeculidDocumentProtocol) {
    self.document = document
  }
}
