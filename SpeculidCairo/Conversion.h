//
//  Conversion.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"
#import "ImageSpecification.h"

@interface Conversion : NSObject

- (void) exportImage: (id<ImageHandle>) imageHandle toURL: (NSURL*) destinationURL withSpecifications: (NSArray<id<ImageSpecification>>*) specfication error:(NSError**) errorPtr;
@end
