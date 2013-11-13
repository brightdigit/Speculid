//
//  MockClient.m
//  tgio-mockInterface
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "MockClient.h"

@implementation MockClient

static MockClient * _client;

+ (id<TgioClient>) connect:(NSString *)applicationId
{
  if (_client == nil)
  {
    _client = [[MockClient alloc] init];
  }

  return _client;
}

- (void) login:(id<LoginRequest>)request target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

- (void) register:(id<RegistrationRequest>)request target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

- (TgioClientType) type
{
  return MockClientType;
}

@end
