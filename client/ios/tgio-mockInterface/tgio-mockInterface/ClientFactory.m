//
//  Interface.m
//  tgio-mockInterface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "ClientFactory.h"
#import "tgio-sdk.h"

@implementation ClientFactory

id<ClientFactory> _instance;

- (void) initialize
{
  NSLog(@"mock");
}

- (InterfaceType) type
{
  return MockInterfaceType;
}

- (void) login:(id<LoginRequest>)request target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

- (void) register:(id<RegistrationRequest>)request target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

+ (id<ClientFactory>) instance
{
  if (!_instance)
  {
    _instance = [[ClientFactory alloc] init];
  }

  return _instance;
}

@end
