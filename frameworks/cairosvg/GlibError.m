//
//  GlibError.m
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import "GlibError.h"

@implementation GlibError

GError * _gerror;

- (GError*) gerror {
  return _gerror;
}

- (id) initWithGError:(GError *)gerror {
  self = [super initWithDomain:@"CairoErrorDomain" code:100 userInfo:nil];
  if (self) {
    _gerror = gerror;
  }
  return self;
}

@end
