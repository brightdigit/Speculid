//
//  main.swift
//  TestSetup
//
//  Created by Leo Dion on 1/17/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

import Foundation

guard let filePath = CommandLine.arguments.last.flatMap({
  URL(fileURLWithPath: $0)
}) else {
  fatalError()
}

guard let enumerator = FileManager.default.enumerator(at: filePath, includingPropertiesForKeys: nil) else {
  fatalError()
}

for case let url as URL in enumerator {
  guard url.pathExtension == "svg" else {
    continue
  }
}

