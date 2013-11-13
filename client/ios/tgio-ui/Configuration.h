//
//  Configuration.h
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tgio-sdk.h"

@protocol ClientFactory;

@interface Configuration : NSObject

+ (id<ClientFactory>) interface __deprecated;
+ (void) configure:(id<ClientFactory>) interface __deprecated;
+ (id<TgioClient>)client;
+ (void) setupWithClient:(id<TgioClient>)client;

@end
