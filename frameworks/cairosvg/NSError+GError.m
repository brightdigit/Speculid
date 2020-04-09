//
//  NSError+GError.m
//  CairoSVG
//
//  Created by Leo Dion on 4/8/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

#import "NSError+GError.h"

@implementation NSError (GError)

- (id) initWithGError:(GError *)gerror withURL:(NSURL * _Nonnull)url {
  NSString * message = [[NSString alloc] initWithUTF8String:gerror->message];
  NSDictionary * underlyingUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys: message, NSLocalizedDescriptionKey, nil];
  NSError * underlyingError = [[NSError alloc] initWithDomain:@"GErrorDomain" code:gerror->code userInfo:underlyingUserInfo];
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:underlyingError, NSUnderlyingErrorKey, url.path, NSFilePathErrorKey, nil];
  self = [self initWithDomain:@"CairoErrorDomain" code:1100 userInfo:newUserInfo];
  return self;
}

@end
