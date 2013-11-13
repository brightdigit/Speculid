//
//  Interface.m
//  tgio-interface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "Interface.h"
#import "tgio-sdk.h"

@implementation Interface

id<Interface> _instance;

- (void) initialize
{
  NSLog(@"prod");
}

+ (id<Interface>) instance
{
  if (!_instance)
  {
    _instance = [[Interface alloc] init];
  }

  return _instance;
}

- (void) login:(id<LoginRequest>)request target:(id)target action:(SEL)selector
{
  [client login:request target:target action:selector];
//  [client login:request target:target selector:selector];
}

- (void) register:(id<RegistrationRequest>)request target:(id)target action:(SEL)selector
{
  [client register:request target:target action:selector];
}

@end
