//
//  main.swift
//  speculid
//
//  Created by Leo Dion on 9/27/16.
//
//

import Foundation

import Speculid


if CommandLine.arguments.count > 1 {
  
  
  let path = CommandLine.arguments[1]
  let speculidURL = URL(fileURLWithPath: path)
  
  if let document = SpeculidDocument(url: speculidURL) {
    /*
     document!.build{
     (error) in
     }
     print(speculidURL)
     */
    if let error = SpeculidBuilder.shared.build(document: document) {
      print(error)
      exit(1)
    }
    
  }
}
