//
//  LoginRequest.m
//  tgio-sdk
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

@synthesize userName = _userName;
@synthesize password = _password;

- (id) initWithUserName:(NSString *)userName andPassword:(NSString *)password
{
  self = [super init];

  if (self)
  {
    _userName = userName;
    _password = password;
  }

  return self;
}

@end
