//
//  ImageHandleBuilder.h
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface ImageHandleBuilder : NSObject
+ (ImageHandleBuilder* _Nonnull) shared;
- (id<ImageHandle> _Nullable) imageHandleFromURL:(NSURL* _Nonnull)url error:(NSError**) error;
@end
NS_ASSUME_NONNULL_END
