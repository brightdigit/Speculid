//
//  PDFSurface.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "SurfaceHandle.h"

NS_ASSUME_NONNULL_BEGIN
@interface PDFSurface : NSObject<SurfaceHandle>
@property (readonly, nonatomic) cairo_surface_t* surface;
- (id) initWithSurface: (cairo_surface_t*) surface;
@end
NS_ASSUME_NONNULL_END
