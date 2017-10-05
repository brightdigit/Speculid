//
//  ImageHandleBuilder.m
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import "ImageHandleBuilder.h"
#import <librsvg/rsvg.h>
#import "SVGImageHandle.h"
#import "PNGImageHandle.h"

ImageHandleBuilder * _shared = nil;

@implementation ImageHandleBuilder
+ (ImageHandleBuilder*) shared {
  if (_shared == nil) {
    _shared = [[ImageHandleBuilder alloc] init];
  }
  
  return _shared;
}

- (id<ImageHandle>) imageHandleFromURL:(NSURL *)url error:(NSError **)error {
  
    if ([url.pathExtension caseInsensitiveCompare:@"svg"] == NSOrderedSame) {
  
      RsvgDimensionData rsvgDimensions;
      GError * error = nil;
      RsvgHandle * rsvgHandle = rsvg_handle_new_from_file(url.path.UTF8String , &error);
//      rsvg_handle_get_dimensions(rsvgHandle, &rsvgDimensions);
//      originalSize = CGSizeMake(rsvgDimensions.width, rsvgDimensions.height);
      return [[SVGImageHandle alloc] initWithRsvgHandle: rsvgHandle];
  
    } else if ([url.pathExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
      cairo_surface_t * sourceSurface = cairo_image_surface_create_from_png(url.path.UTF8String);
//      originalSize = CGSizeMake(cairo_image_surface_get_width(sourceSurface), cairo_image_surface_get_height(sourceSurface));
      return [[PNGImageHandle alloc] initWithSurface: sourceSurface];
  
    }
  return nil;
}
@end
