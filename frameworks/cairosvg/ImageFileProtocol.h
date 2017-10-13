//
//  ImageFileProtocol.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFileFormat.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ImageFileProtocol <NSObject>
@property (readonly) NSURL * _Nonnull url;
@property (readonly) ImageFileFormat format;
@end
NS_ASSUME_NONNULL_END
