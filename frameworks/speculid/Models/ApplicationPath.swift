//
//  ApplicationPath.swift
//  speculid
//
//  Created by Leo Dion on 10/18/16.
//
//

@available(*, deprecated: 2.0.0)
public enum ApplicationPath : String {
  case inkscape = "inkscape",
  convert  = "convert"
  
  public static let values : [ApplicationPath] = [.inkscape, .convert]
}
