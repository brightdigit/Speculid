//
//  main.swift
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/5/17.
//

import Foundation


@objc public class SpeculidService : NSObject, SpeculidServiceProtocol {
  public func uppercaseString(_ string: String, withReply callback: (String) -> Void) {
    callback(string.uppercased())
  }
}

@objc public class ServiceDelegate : NSObject, NSXPCListenerDelegate {

  public func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    // This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.
    
    // Configure the connection.
    // First, set the interface that the exported object implements.
    
    newConnection.exportedInterface = NSXPCInterface(with: SpeculidServiceProtocol.self)
    //newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Speculid_Mac_XPCProtocol)];
    
    // Next, set the object that the connection exports. All messages sent on the connection to this service will be sent to the exported object to handle. The connection retains the exported object.
    let exportedObject = SpeculidService()
    //Speculid_Mac_XPC *exportedObject = [Speculid_Mac_XPC new];
    //newConnection.exportedObject = exportedObject;
    newConnection.exportedObject = exportedObject
    
    // Resuming the connection allows the system to deliver more incoming messages.
    //[newConnection resume];
    newConnection.resume()
    
    // Returning YES from this method tells the system that you have accepted this connection. If you want to reject the connection for some reason, call -invalidate on the connection and return NO.
    //return YES;
    return true
  }
}


// Create the delegate for the service.
let delegate = ServiceDelegate()

// Set up the one NSXPCListener for this service. It will handle all incoming connections.
//NSXPCListener *listener = [NSXPCListener serviceListener];
let listener = NSXPCListener.service()
listener.delegate = delegate

// Resuming the serviceListener starts this service. This method does not return.
listener.resume()
