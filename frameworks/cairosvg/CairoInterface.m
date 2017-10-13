//
//  RSVG.m
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import "rsvg.h"
#import "cairo.h"
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
  switch (dimensions.dimension) {
    case kWidth:
      return dimensions.value/size.width;
    case kHeight:
      return dimensions.value/size.height;
  }
}

+ (BOOL)exportImage:(id<ImageHandle>)sourceHandle withSpecification:(id<ImageSpecificationProtocol>)specification error:(NSError * _Nullable __autoreleasing *)error {
  
  NSError * surfaceError;
  
  double scale = [self mapSize: sourceHandle.size toDimension: specification.geometry];
  
  CairoSize size;
  size.width = (int)(sourceHandle.size.width * scale);
  size.height = (int)(sourceHandle.size.height * scale);
  id<SurfaceHandle> surface = [[SurfaceHandleBuilder shared] surfaceHandleForFile:specification.file withSize:size andAlphaChannel:!(specification.removeAlphaChannel) error:&surfaceError];
  
  if (surfaceError) {
    *error = surfaceError;
    return NO;
  }
  
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
  
  return YES;
}
@end
