//
//  PNGImageHandle.m
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import "PNGImageHandle.h"

@implementation PNGImageHandle
-(CGSize)size {
  return CGSizeMake(cairo_image_surface_get_width([self cairoHandle]), cairo_image_surface_get_height([self cairoHandle]));
}

-(BOOL)paintTo:(cairo_t *)renderer {
  cairo_set_source_surface(renderer, [self cairoHandle], 0, 0);
  cairo_paint(renderer);
  return true;
}
@end
