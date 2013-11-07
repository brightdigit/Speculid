//
//  Configuration.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "Configuration.h"
#import "Interface.h"

@implementation Configuration

static id<Interface> _interface = nil;

+ (id<Interface>) interface
{
  return _interface;
}

+ (void) configure:(id<Interface>)interface
{
  [interface initialize];
  _interface = interface;
}

@end
