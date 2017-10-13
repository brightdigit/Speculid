//
//  ImageSpecificationProtocol.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//
import Foundation

public protocol AssetSpecificationProtocol {
  var idiom : ImageIdiom { get }
  var scale : CGFloat? { get }
  var size : CGSize? { get }
  var filename : String? { get }
}
