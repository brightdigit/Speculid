//
//  TgioConfiguration.h
//  tgio-sdk
//
//  Created by Leo G Dion on 11/13/13.
//  Copyright (c) 2013 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TgioConfiguration <NSObject>

- (NSString *) baseUrl;
- (NSString *) appId;

@end

@interface TgioConfiguration : NSDictionary<TgioConfiguration>

+ (id<TgioConfiguration>)mainConfiguration;

@end
