//
//  main.swift
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/9/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

import Foundation

let delegate = ServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()

