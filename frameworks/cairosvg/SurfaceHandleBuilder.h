//
//  SurfaceHandleBuilder.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurfaceHandle.h"
#import "ImageFileProtocol.h"
#import "CairoSize.h"

NS_ASSUME_NONNULL_BEGIN
@interface SurfaceHandleBuilder : NSObject
@property (class, nonatomic, assign, readonly) SurfaceHandleBuilder* _Nonnull shared;
- (id<SurfaceHandle> _Nullable) surfaceHandleForFile: (id<ImageFileProtocol> _Nonnull) file withSize: (CairoSize) size andAlphaChannel: (BOOL) containsAlphaChannel error:(NSError**) error;
@end
NS_ASSUME_NONNULL_END
