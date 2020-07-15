//
//  CairoColorProtocol.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CairoColorProtocol <NSObject>
@property (readonly) double red;
@property (readonly) double green;
@property (readonly) double blue;
@end
NS_ASSUME_NONNULL_END
