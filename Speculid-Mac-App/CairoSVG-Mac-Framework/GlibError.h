//
//  GlibError.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <librsvg/rsvg.h>

@interface GlibError : NSError

@property (readonly) GError * _Nonnull gerror;
- (id) initWithGError: (GError *  _Nonnull) gerror;
@end
