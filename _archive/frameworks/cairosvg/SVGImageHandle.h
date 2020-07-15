//
//  SVGImageHandle.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "rsvg.h"
#import "ImageHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface SVGImageHandle : NSObject<ImageHandle>
@property RsvgHandle * rsvgHandle;
- (id) initWithRsvgHandle:(RsvgHandle *) rsvgHandle;
@end
NS_ASSUME_NONNULL_END
