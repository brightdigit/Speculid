//
//  Interface.h
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tgio-sdk.h"

@protocol ClientFactory <NSObject>

typedef enum
{
  ProductionInterfaceType,
  MockInterfaceType
} InterfaceType;

@optional
- (InterfaceType) type __deprecated;
- (void) initialize __deprecated;
- (void) login:(id<LoginRequest>) request target:(id) target action:(SEL) selector __deprecated;
- (void) register :(id<RegistrationRequest>) request target:(id) target action:(SEL) selector __deprecated;

+ (id<ClientFactory>)instance;
- (id<TgioClient>)clientWithConfiguration:(id) configuration;

@end
