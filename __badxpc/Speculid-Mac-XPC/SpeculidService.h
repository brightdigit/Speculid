//
//  Speculid_Mac_XPC.h
//  Speculid-Mac-XPC
//
//  Created by Leo Dion on 10/5/17.
//

#import <Foundation/Foundation.h>
#import "SpeculidServiceProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface SpeculidService : NSObject <SpeculidServiceProtocol>
@end
