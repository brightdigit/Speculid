//
//  SVGImageHandle.m
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import "SVGImageHandle.h"

@implementation SVGImageHandle
-(CGSize)size {
      RsvgDimensionData rsvgDimensions;
      rsvg_handle_get_dimensions([self rsvgHandle], &rsvgDimensions);
     return CGSizeMake(rsvgDimensions.width, rsvgDimensions.height);
}

-(BOOL)paintTo:(cairo_t *)renderer {
  return rsvg_handle_render_cairo([self rsvgHandle], renderer);
}

- (id) initWithRsvgHandle:(RsvgHandle *) rsvgHandle {
  self.rsvgHandle = rsvgHandle;
  return [super init];
}
@end
