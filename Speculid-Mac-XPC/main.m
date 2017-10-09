//
//  main.m
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/5/17.
//

#import <Foundation/Foundation.h>
//#import "Speculid_Mac_XPC-Swift.h"
#import "ServiceDelegate.h"

int main(int argc, const char *argv[])
{
    // Create the delegate for the service.
    ServiceDelegate *delegate = [ServiceDelegate new];
    
    // Set up the one NSXPCListener for this service. It will handle all incoming connections.
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;
    
    // Resuming the serviceListener starts this service. This method does not return.
    [listener resume];
    return 0;
}
