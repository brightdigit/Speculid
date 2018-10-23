//
//  Speculid_Mac_Installer.m
//  Speculid-Mac-Installer
//
//  Created by Leo Dion on 10/22/18.
//  Copyright © 2018 Bright Digit, LLC. All rights reserved.
//

#import "Speculid_Mac_Installer.h"

@implementation Speculid_Mac_Installer

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
