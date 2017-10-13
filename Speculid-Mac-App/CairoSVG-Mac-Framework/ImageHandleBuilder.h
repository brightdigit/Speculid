//
//  ImageHandleBuilder.h
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "ImageFileProtocol.h"
#import "ImageHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface ImageHandleBuilder : NSObject
@property (class, nonatomic, assign, readonly) ImageHandleBuilder* _Nonnull shared;
- (id<ImageHandle> _Nullable) imageHandleFromFile: (id<ImageFileProtocol> _Nonnull) file error:(NSError**) error;
@end
NS_ASSUME_NONNULL_END
