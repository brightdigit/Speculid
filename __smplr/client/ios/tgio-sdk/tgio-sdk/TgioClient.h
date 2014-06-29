//
//  TgioClient.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/12/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TgioConfiguration.h"

@protocol TgioClient <NSObject>

typedef enum
{
  ProductionClientType,
  MockClientType
} TgioClientType;

// + (id<TgioClient>)connect:(NSString *) applicationId;
- (id) initWithConfiguration: (id<TgioConfiguration>) configuration;
- (void) login:(id<LoginRequest>) request target:(id) target action:(SEL) selector;
- (void) register :(id<RegistrationRequest>) request target:(id) target action:(SEL) selector;

@optional
- (TgioClientType) type;

@end

@interface TgioClient : NSObject<TgioClient> {
  NSString * _baseUrl;
}

@end
