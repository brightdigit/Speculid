//
//  Speculid_Mac_XPC.m
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/5/17.
//

#import "SpeculidService.h"

@implementation SpeculidService

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
