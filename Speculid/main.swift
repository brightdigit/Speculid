//
//  main.swift
//  speculid
//
//  Created by Leo Dion on 9/26/16.
//
//

import Foundation
import Speculid

print("Hello, World!")
let path = CommandLine.arguments[1]
let speculidURL = URL(fileURLWithPath: path)

if let document = SpeculidDocument(url: speculidURL) {
  /*
   document!.build{
   (error) in
   }
   print(speculidURL)
   */
  SpeculidBuilder.shared.build(document: document, callback: {
    (error) in
    
    exit(error == nil ? 0 : 1)
  })
}

