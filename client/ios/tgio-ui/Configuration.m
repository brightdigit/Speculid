//
//  Configuration.m
//  tgio-ui
//
//  Created by Leo G Dion on 11/5/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "Configuration.h"
#import "ClientFactory.h"

@implementation Configuration

static id<ClientFactory> _interface = nil;
static id<TgioClient> _client = nil;

+ (id<ClientFactory>) interface
{
  return _interface;
}

+ (void) configure:(id<ClientFactory>)interface
{
  [interface initialize];
  _interface = interface;
}

+ (void) setupWithClient:(id<TgioClient>)client
{
  _client = client;
}

+ (id<TgioClient>) client
{
  return _client;
}

@end
