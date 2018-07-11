//
//  ImageHandleBuilder.h
//  CairoSVG
//
//  Created by Leo Dion on 6/28/18.
//

#import <Foundation/Foundation.h>
#import <rsvg.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageHandleBuilder : NSObject
- (RsvgHandle *)rsvgHandleFromURL:(NSURL*) url;
@end

NS_ASSUME_NONNULL_END
