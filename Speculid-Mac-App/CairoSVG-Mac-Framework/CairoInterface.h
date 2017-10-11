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

NS_ASSUME_NONNULL_BEGIN
@interface CairoInterface : NSObject
+  (BOOL)exportImage:(id<ImageHandle> _Nonnull) sourceHandle toURL:(NSURL* _Nonnull) destinationURL withDimensions: (struct GeometryDimension) dimensions shouldRemoveAlphaChannel: (BOOL) removeAlphaChannel setBackgroundColor: (CGColorRef _Nullable) backgroundColor error: (NSError **) error;
@end
NS_ASSUME_NONNULL_END
