//
//  PNGSurface.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import <cairo-pdf.h>
#import "SurfaceHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface PNGSurface : NSObject<SurfaceHandle>
@property (readonly, nonatomic) NSURL* url;
@property (readonly, nonatomic) cairo_format_t format;
@property (readonly, nonatomic) cairo_surface_t* surface;
- (id) initWithSurface: (cairo_surface_t*) surface format: (cairo_format_t) format andDestinationURL: (NSURL*) url;
@end
NS_ASSUME_NONNULL_END
