//
//  ImageFileProtocol.h
//  CairoSVG
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFileFormat.h"
@protocol ImageFileProtocol <NSObject>
@property (readonly) NSURL * _Nonnull url;
@property (readonly) ImageFileFormat format;
@end
