//
//  PDFSurface.m
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import "cairo.h"
#import "PDFSurface.h"

@implementation PDFSurface
- (id) initWithSurface:(cairo_surface_t *)surface {
  self = [super init];
  if (self) {
    _surface = surface;
  }
  return self;
}

- (cairo_t *)cairo {
  return cairo_create(self.surface);
}

- (BOOL)finishWithError:(NSError *__autoreleasing *)error {
  return YES;
}

@end
