//
//  RSVG.m
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import </usr/local/include/librsvg-2.0/librsvg/rsvg.h>

#import "RSVG.h"

@implementation RSVG
+ (NSObject*)classMethod
{
  GError * error = nil;
  RsvgHandle * handle = rsvg_handle_new_from_file( "/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.svg", &error);
  
  cairo_surface_t*  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 900, 900);
  cairo_t* cr = cairo_create(surface);
  BOOL result = rsvg_handle_render_cairo(handle, cr);
  cairo_status_t status = cairo_surface_write_to_png(surface, "/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.png");
  
  
  return nil;
}

@end
