//
//  SurfaceHandle.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "cairo.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SurfaceHandle <NSObject>
- (cairo_t *) cairo;
- (BOOL) finishWithError: (NSError **) error;
@end
NS_ASSUME_NONNULL_END
