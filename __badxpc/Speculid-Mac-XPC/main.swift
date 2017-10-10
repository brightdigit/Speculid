//
//  main.swift
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/5/17.
//

import Foundation






// Create the delegate for the service.
let delegate = ServiceDelegate()

// Set up the one NSXPCListener for this service. It will handle all incoming connections.
//NSXPCListener *listener = [NSXPCListener serviceListener];
let listener = NSXPCListener.service()
listener.delegate = delegate

// Resuming the serviceListener starts this service. This method does not return.
listener.resume()
