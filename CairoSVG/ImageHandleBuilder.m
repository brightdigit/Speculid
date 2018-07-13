//
//  ImageHandleBuilder.m
//  CairoSVG
//
//  Created by Leo Dion on 6/28/18.
//

#import "ImageHandleBuilder.h"
//#import "GlibError.h"

@implementation ImageHandleBuilder

- (RsvgHandle *)rsvgHandleFromURL:(NSURL*) url{
    GError * gerror = nil;
  RsvgHandle * rsvgHandle;
  rsvgHandle = rsvg_handle_new_from_file(url.path.UTF8String , &gerror);
  
  return rsvgHandle;
}
@end
