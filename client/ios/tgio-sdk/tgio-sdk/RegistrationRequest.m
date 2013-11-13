//
//  RegistrationRequest.m
//  tgio-sdk
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "RegistrationRequest.h"

@implementation RegistrationRequest

@synthesize emailAddress = _emailAddress;

- (id) initWithEmailAddress:(NSString *)emailAddress
{
  self = [super init];

  if (self)
  {
    _emailAddress = emailAddress;
  }

  return self;
}

@end
