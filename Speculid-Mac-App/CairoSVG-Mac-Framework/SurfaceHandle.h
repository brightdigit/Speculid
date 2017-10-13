//
//  SurfaceHandle.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <cairo-pdf.h>
#import <Foundation/Foundation.h>

@protocol SurfaceHandle <NSObject>
- (cairo_t *) cairo;
- (BOOL) finishWithError: (NSError **) error;
@end
