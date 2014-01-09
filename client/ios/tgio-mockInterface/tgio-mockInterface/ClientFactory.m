//
//  Interface.m
//  tgio-mockInterface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "ClientFactory.h"
#import "MockClient.h"
#import "tgio-sdk.h"

@implementation ClientFactory

static ClientFactory * _instance;

- (id<TgioClient>) clientWithConfiguration:(id)configuration
{
  return nil;
}

+ (id<ClientFactory>) instance
{
  if (_instance == nil)
  {
    _instance = [[ClientFactory alloc] init];
  }
  return _instance;
}

@end
