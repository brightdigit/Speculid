//
//  PNGSurface.m
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import "PNGSurface.h"

@implementation PNGSurface

- (id) initWithSurface:(cairo_surface_t *)surface format:(cairo_format_t)format andDestinationURL:(nonnull NSURL *)url {
  self = [super init];
  if (self) {
    _format = format;
    _surface = surface;
    _url = url;
  }
  return self;
}

- (cairo_t *)cairo {
  return cairo_create(self.surface);
}

- (NSError *)errorFromStatus: (cairo_status_t) status {
  return nil;
}

- (BOOL)finishWithError:(NSError *__autoreleasing *)error {
  
  cairo_status_t status = cairo_surface_write_to_png(self.surface, self.url.path.UTF8String);
  *error = [self errorFromStatus: status];
  return error == nil;
}

@end
