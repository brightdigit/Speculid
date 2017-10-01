//
//  RSVG.h
//  obj-librsvg
//
//  Created by Leo Dion on 9/21/17.
//  Copyright © 2017 Leo Dion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSVG : NSObject
+ (void)createPNGFromSVG;
+ (void)createPDFFromSVG;
+ (void)createPNGFromPNG;
+ (void)exportImageAtURL:(NSURL*) sourceURL toURL:(NSURL*) destinationURL error: (NSError**) errorptr;
@end
