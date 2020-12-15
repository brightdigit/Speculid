//
//  RSVG.h
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"
#import "GeometryDimension.h"
#import "ImageSpecificationProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@interface CairoInterface : NSObject
+  (BOOL)exportImage:(id<ImageHandle> _Nonnull) sourceHandle withSpecification: (id<ImageSpecificationProtocol> _Nonnull) specification error: (NSError **) error;
@end
NS_ASSUME_NONNULL_END
