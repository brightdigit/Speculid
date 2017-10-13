//
//  SurfaceHandleBuilder.m
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <cairo-pdf.h>
#import "SurfaceHandleBuilder.h"
#import "PNGSurface.h"
#import "PDFSurface.h"

@implementation SurfaceHandleBuilder
static SurfaceHandleBuilder * _shared = nil;

+ (SurfaceHandleBuilder*) shared {
  if (_shared == nil) {
    _shared = [[SurfaceHandleBuilder alloc] init];
  }
  
  return _shared;
}

- (id<SurfaceHandle>) surfaceHandleForFile:(id<ImageFileProtocol>)file withSize:(CairoSize)size  andAlphaChannel:(BOOL)containsAlphaChannel error:(NSError * _Nullable __autoreleasing * _Nullable)error {
  
  cairo_format_t format;
  cairo_surface_t* destinationSurface;
    switch (file.format) {
      case kPng:
        format = containsAlphaChannel ? CAIRO_FORMAT_RGB24 : CAIRO_FORMAT_ARGB32;
        destinationSurface = cairo_image_surface_create(format, size.width, size.height);
        return [[PNGSurface alloc] initWithSurface:destinationSurface format:format andDestinationURL:file.url];
      case kPdf:
        destinationSurface = cairo_pdf_surface_create(file.url.path.UTF8String, size.width, size.height);
        return [[PDFSurface alloc] initWithSurface: destinationSurface];
        break;
      default:
        *error = [[NSError alloc] initWithDomain:@"CairoErrorDomain" code:200 userInfo:nil];
        return nil;
    }
  
}
@end
