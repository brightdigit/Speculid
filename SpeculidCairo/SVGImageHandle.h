//
//  SVGImageHandle.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import <librsvg/rsvg.h>
#import "ImageHandle.h"

@interface SVGImageHandle : NSObject<ImageHandle>
@property RsvgHandle * rsvgHandle;
@end
