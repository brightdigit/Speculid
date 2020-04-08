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
NSURL * _sourceURL;

- (GError*) gerror {
  return _gerror;
}

- (NSURL*) sourceURL {
  return _sourceURL;
}


- (id) initWithGError:(GError *)gerror withURL:(NSURL * _Nonnull)url {
  self = [super initWithDomain:@"CairoErrorDomain" code:100 userInfo:nil];
  if (self) {
    _gerror = g_error_copy(gerror);
    _sourceURL = url;
  }
  return self;
}

- (NSString *)localizedDescription {
  // "There is no file \"\(contentsName)\" located at the set: \"\(filePathDirURL.path)\"."
  return [ [NSString alloc] initWithFormat:@"Unable to read file \"%@\". The file either missing or malformed.", self.sourceURL.path];
}

@end
