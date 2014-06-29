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
  return [[TgioClient alloc] initWithConfiguration:configuration];
}

+ (id<ClientFactory>) instance
{
  return nil;
}

@end
