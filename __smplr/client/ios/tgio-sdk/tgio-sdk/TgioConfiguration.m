//
//  TgioConfiguration.m
//  tgio-sdk
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import "TgioConfiguration.h"

@implementation TgioConfiguration

- (id) initWithInfoDictionaryObject:(id)infoDictionaryObject
{
  self = [super init];

  if (self)
  {
    [self setValuesForKeysWithDictionary:infoDictionaryObject];
  }

  return self;
}

+ (id<TgioConfiguration>) mainConfiguration
{
  return [[TgioConfiguration alloc] initWithInfoDictionaryObject:[[NSBundle mainBundle] infoDictionary]];
}

@end
