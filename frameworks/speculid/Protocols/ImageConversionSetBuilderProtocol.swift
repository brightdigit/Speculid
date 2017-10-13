//
//  ImageConversionSetBuilderProtocol.swift
//  Speculid
//
//  Created by Leo Dion on 9/30/17.
//

import Foundation

public protocol ImageConversionSetBuilderProtocol {
  func buildConversions(forDocument document: SpeculidDocumentProtocol, withConfiguration configuration: SpeculidConfigurationProtocol) -> ImageConversionSetProtocol?
}
