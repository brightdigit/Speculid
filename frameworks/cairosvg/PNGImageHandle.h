//
//  PNGImageHandle.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"
#import <cairo.h>

NS_ASSUME_NONNULL_BEGIN
@interface PNGImageHandle : NSObject<ImageHandle>
@property cairo_surface_t * cairoHandle;
- (id) initWithSurface:(cairo_surface_t *) cairoHandle;
@end
NS_ASSUME_NONNULL_END
