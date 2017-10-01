//
//  ImageHandle.h
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import <cairo.h>

@protocol ImageHandle <NSObject>
-(CGSize) size;
-(BOOL) paintTo:(cairo_t*) renderer;
@end
