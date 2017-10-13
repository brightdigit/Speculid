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
#import "GeometryDimension.h"
#import "ImageFileFormat.h"
#import "SurfaceHandle.h"
#import "SurfaceHandleBuilder.h"
#import "CairoSize.h"

@implementation CairoInterface

+ (double) mapSize: (CGSize) size toDimension: (GeometryDimension) dimensions {
  double result = NAN;
  switch (dimensions.dimension) {
    case kWidth:
      return dimensions.value/size.width;
    case kHeight:
      return dimensions.value/size.height;
  }
}

+ (BOOL)exportImage:(id<ImageHandle>)sourceHandle withSpecification:(id<ImageSpecificationProtocol>)specification error:(NSError * _Nullable __autoreleasing *)error {
  //cairo_surface_t*  destinationSurface;
  NSError * surfaceError;
  //id<SurfaceHandle> surface = [[SurfaceHandleBuilder shared] surfaceHandleFromFile:specification.file error:&surfaceError];
  double scale = [self mapSize: sourceHandle.size toDimension: specification.geometry];
  
  CairoSize size;
  size.width = (int)(sourceHandle.size.width * scale);
  size.height = (int)(sourceHandle.size.height * scale);
  id<SurfaceHandle> surface = [[SurfaceHandleBuilder shared] surfaceHandleForFile:specification.file withSize:size andAlphaChannel:!(specification.removeAlphaChannel) error:&surfaceError];
  
  if (surfaceError) {
    *error = surfaceError;
    return NO;
  }
  
//  cairo_format_t format = CAIRO_FORMAT_INVALID;
//
//  switch (specification.file.format) {
//    case kPng:
//      format = specification.removeAlphaChannel ? CAIRO_FORMAT_RGB24 : CAIRO_FORMAT_ARGB32;
//      destinationSurface = cairo_image_surface_create(format, (int)(sourceHandle.size.width * scale), (int)(sourceHandle.size.height * scale));
//      break;
//    case kPdf:
//      destinationSurface = cairo_pdf_surface_create(specification.file.url.path.UTF8String,sourceHandle.size.width * scale, sourceHandle.size.height * scale);
//      break;
//    default:
//      *error = [[NSError alloc] initWithDomain:@"CairoErrorDomain" code:200 userInfo:nil];
//      return NO;
//  }
//
  
  //cairo_t* cr = cairo_create(destinationSurface);
  cairo_t* cr = [surface cairo];

  if (specification.backgroundColor != nil) {
    cairo_set_source_rgb (cr, specification.backgroundColor.red,  specification.backgroundColor.green, specification.backgroundColor.blue);
    cairo_paint(cr);
  }
  
  cairo_scale(cr, scale, scale);
  
  BOOL result = [sourceHandle paintTo:cr];
  
  if (!result) {
    *error = [[NSError alloc] initWithDomain:@"CairoErrorDomain" code:200 userInfo:nil];
    return NO;
  }
  
  NSError * finishError;
  [surface finishWithError: &finishError];
  
  if (finishError) {
    *error = finishError;
    return NO;
  }
//  if (format != CAIRO_FORMAT_INVALID) {
//
//    cairo_status_t status = cairo_surface_write_to_png(destinationSurface, specification.file.url.path.UTF8String);
//  }
  
  return YES;
}

+ (BOOL)exportImage:(id<ImageHandle>) sourceHandle toURL:(NSURL*) destinationURL withDimensions: (struct GeometryDimension) dimensions shouldRemoveAlphaChannel: (BOOL) removeAlphaChannel setBackgroundColor: (CGColorRef) backgroundColor error: (NSError**) error {

  cairo_surface_t*  destinationSurface;
  
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
  
  if (format != CAIRO_FORMAT_INVALID) {
    
    cairo_status_t status = cairo_surface_write_to_png(destinationSurface, destinationURL.path.UTF8String);
    NSLog(@"%@, %@", destinationURL.path.UTF8String, status);
  }
  
  return result;
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
