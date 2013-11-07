//
//  Interface.m
//  tgio-mockInterface
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "Interface.h"

@implementation Interface

id<Interface> _instance;

- (void) initialize
{
  NSLog(@"mock");
}

+ (id<Interface>) instance
{
  if (!_instance)
  {
    _instance = [[Interface alloc] init];
  }

  return _instance;
}

@end
