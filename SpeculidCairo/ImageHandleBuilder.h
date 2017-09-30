//
//  ImageHandleBuilder.h
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"

@interface ImageHandleBuilder : NSObject
+ (ImageHandleBuilder*) shared;
- (id<ImageHandle>) imageHandleFromURL:(NSURL*)url;
@end
