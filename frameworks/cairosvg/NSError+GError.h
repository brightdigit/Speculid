//
//  NSError+GError.h
//  CairoSVG
//
//  Created by Leo Dion on 4/8/20.
//  Copyright © 2020 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rsvg.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSError (GError)
- (id) initWithGError: (GError *  _Nonnull) gerror withURL: (NSURL * _Nonnull) url;
@end

NS_ASSUME_NONNULL_END
