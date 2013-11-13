//
//  Interface.m
//  tgio-interface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "ClientFactory.h"
#import "tgio-sdk.h"

@implementation ClientFactory

- (id<TgioClient>) clientWithConfiguration:(id)configuration
{
  return nil;
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
