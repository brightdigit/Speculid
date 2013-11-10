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

- (InterfaceType) type
{
  return MockInterfaceType;
}

- (void) loginUser:(NSString *)name withPassword:(NSString *)password target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

- (void) registerEmailAddress:(NSString *)emailAddress target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
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
