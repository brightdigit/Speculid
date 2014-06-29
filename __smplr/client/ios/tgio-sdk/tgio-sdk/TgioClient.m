//
//  TgioClient.m
//  tgio-sdk
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "tgio-sdk.h"
#import "TgioClient.h"

#import <RestKit/RestKit.h>

@implementation TgioClient

- (id) initWithConfiguration:(id<TgioConfiguration>)configuration
{
  self = [super init];
  
  if (self) {
    _baseUrl = [configuration baseUrl];
  }
  
  return self;
}

- (void) login:(id<LoginRequest>)request target:(id)target action:(SEL)selector
{
  [target performSelector:selector withObject:nil afterDelay:5.0];
}

- (void) register:(id<RegistrationRequest>)request target:(id)target action:(SEL)selector
{
  RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:_baseUrl]];
  manager addRequestDescriptor:[RKRequestDescriptor map]
  //[target performSelector:selector withObject:nil afterDelay:5.0];
}

@end
