//
//  RSVG.h
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"

typedef NS_ENUM(NSUInteger, Dimension) {
  kWidth,
  kHeight
};

struct GeometryDimension {
  double value;
  Dimension dimension;
};

@interface RSVG : NSObject
+ (void)createPNGFromSVG;
+ (void)createPDFFromSVG;
+ (void)createPNGFromPNG;
+  (void)exportImage:(id<ImageHandle>) sourceHandle toURL:(NSURL*) destinationURL withDimensions: (struct GeometryDimension) dimensions shouldRemoveAlphaChannel: (BOOL) removeAlphaChannel setBackgroundColor: (CGColorRef) backgroundColor error: (NSError**) errorptr;
@end
