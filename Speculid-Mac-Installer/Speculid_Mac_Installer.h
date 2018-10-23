//
//  Speculid_Mac_Installer.h
//  Speculid-Mac-Installer
//
//  Created by Leo Dion on 10/22/18.
//  Copyright © 2018 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Speculid_Mac_InstallerProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface Speculid_Mac_Installer : NSObject <Speculid_Mac_InstallerProtocol>
@end
