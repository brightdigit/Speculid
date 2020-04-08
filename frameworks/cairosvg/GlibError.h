//
//  GlibError.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rsvg.h"

NS_ASSUME_NONNULL_BEGIN
@interface GlibError : NSError
@property (readonly, copy) NSURL * _Nonnull sourceURL;
@property (readonly) GError * _Nonnull gerror;
- (id) initWithGError: (GError *  _Nonnull) gerror withURL: (NSURL * _Nonnull) url;
@end
NS_ASSUME_NONNULL_END
