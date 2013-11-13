//
//  Interface.h
//  tgio-interface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tgio-sdk.h"
#import "../../tgio-ui/ClientFactory.h"

@interface ClientFactory : NSObject<ClientFactory> {
  id<TgioClient> client;
}

@end
