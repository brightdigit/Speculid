//
//  RSVG.m
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import <librsvg/rsvg.h>
#import <cairo-pdf.h>

#import "CairoInterface.h"
#import "ImageHandle.h"
#import "ImageHandleBuilder.h"


@implementation CairoInterface

+ (double) mapSize: (CGSize) size toDimension: (struct GeometryDimension) dimensions {
  double result = NAN;
  switch (dimensions.dimension) {
    case kWidth:
      return dimensions.value/size.width;
    case kHeight:
      return dimensions.value/size.height;
  }
}

+ (void)exportImage:(id<ImageHandle>) sourceHandle toURL:(NSURL*) destinationURL withDimensions: (struct GeometryDimension) dimensions shouldRemoveAlphaChannel: (BOOL) removeAlphaChannel setBackgroundColor: (CGColorRef) backgroundColor error: (NSError**) errorptr {

  //RsvgHandle * rsvgHandle;
  //cairo_surface_t*  sourceSurface;
  cairo_surface_t*  destinationSurface;
  
//  if ([sourceURL.pathExtension caseInsensitiveCompare:@"svg"] == NSOrderedSame) {
//
//    RsvgDimensionData rsvgDimensions;
//    GError * error = nil;
//    rsvgHandle = rsvg_handle_new_from_file(sourceURL.absoluteString.UTF8String , &error);
//    rsvg_handle_get_dimensions(rsvgHandle, &rsvgDimensions);
//    originalSize = CGSizeMake(rsvgDimensions.width, rsvgDimensions.height);
//
//  } else if ([sourceURL.pathExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
//    sourceSurface = cairo_image_surface_create_from_png("/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.png");
//    originalSize = CGSizeMake(cairo_image_surface_get_width(sourceSurface), cairo_image_surface_get_height(sourceSurface));
//
//  }
  
  double scale = [self mapSize: sourceHandle.size toDimension: dimensions];
  cairo_format_t format = CAIRO_FORMAT_INVALID;
  
  if ([destinationURL.pathExtension caseInsensitiveCompare:@"png"] == NSOrderedSame) {
    format = removeAlphaChannel ? CAIRO_FORMAT_RGB24 : CAIRO_FORMAT_ARGB32;
    destinationSurface = cairo_image_surface_create(format, (int)(sourceHandle.size.width * scale), (int)(sourceHandle.size.height * scale));
  } else if ([destinationURL.pathExtension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
    destinationSurface = cairo_pdf_surface_create(destinationURL.path.UTF8String,sourceHandle.size.width * scale, sourceHandle.size.height * scale);
  }
  
  cairo_t* cr = cairo_create(destinationSurface);
  
  if (backgroundColor != nil) {
    const CGFloat* components = CGColorGetComponents(backgroundColor);
    cairo_set_source_rgb (cr, components[0],  components[1],  components[2]);
    cairo_paint(cr);
  }
  
  cairo_scale(cr, scale, scale);
  
  BOOL result = [sourceHandle paintTo:cr];
//  if (sourceSurface != nil) {
//    cairo_set_source_surface(cr, sourceSurface, 0, 0);
//    cairo_paint(cr);
//  } else if (rsvgHandle != nil) {
//    BOOL result = rsvg_handle_render_cairo(rsvgHandle, cr);
//  }
  
  if (format != CAIRO_FORMAT_INVALID) {
    
    cairo_status_t status = cairo_surface_write_to_png(destinationSurface, destinationURL.path.UTF8String);
    NSLog(@"%@, %@", destinationURL.path.UTF8String, status);
  }
  
  
}

+ (void)createPNGFromSVG
{
  GError * error = nil;
  RsvgDimensionData dimensions;
  RsvgHandle * handle = rsvg_handle_new_from_file( "/Users/leo/Documents/Projects/speculid/examples/Assets/geometry.svg", &error);
  rsvg_handle_get_dimensions(handle, &dimensions);
  NSLog(@"%d %d", dimensions.width, dimensions.height);
  cairo_surface_t*  surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, dimensions.width * 0.5, dimensions.height * 0.5);
  
  
  cairo_t* cr = cairo_create(surface);
  cairo_set_source_rgb (cr, 1, 0, 0);
  //cairo_rectangle (cr, 0, 0, dimensions.width * 0.5, dimensions.height * 0.5);
  cairo_paint(cr);

  
  cairo_scale(cr, 0.5, 0.5);
  BOOL result = rsvg_handle_render_cairo(handle, cr);
  cairo_status_t status = cairo_surface_write_to_png(surface, "/Users/leo/Documents/Projects/speculid/Speculid_Mac_App/assets/layers.png");
}

+ (void)createPDFFromSVG
{
  
  GError * error = nil;
  RsvgDimensionData dimensions;
  RsvgHandle * handle = rsvg_handle_new_from_file( "/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.svg", &error);
  rsvg_handle_get_dimensions(handle, &dimensions);
  NSLog(@"%d %d", dimensions.width, dimensions.height);
  cairo_surface_t*  surface = cairo_pdf_surface_create("/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.pdf",dimensions.width * 0.5, dimensions.height * 0.5);
  
  cairo_t* cr = cairo_create(surface);
  cairo_scale(cr, 0.5, 0.5);
  BOOL result = rsvg_handle_render_cairo(handle, cr);
  //cairo_status_t status = cairo_surface_write_to_png(surface, "/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.png");
  cairo_destroy(cr);
  cairo_surface_destroy(surface);
}

+ (void)createPNGFromPNG
{
  
  
  cairo_surface_t*  sourceSurface = cairo_image_surface_create_from_png("/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry.png");
  cairo_surface_t*  destinationSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, cairo_image_surface_get_width(sourceSurface) * 2, cairo_image_surface_get_height(sourceSurface) * 2);
  cairo_t* cr = cairo_create(destinationSurface);
  
  
  cairo_scale(cr, 2, 2);
  cairo_set_source_surface(cr, sourceSurface, 0, 0);
  cairo_paint(cr);
  cairo_status_t status = cairo_surface_write_to_png(destinationSurface, "/Users/leo/Documents/Projects/obj-librsvg/obj_librsvgTests/geometry@2x.png");
}
@end
