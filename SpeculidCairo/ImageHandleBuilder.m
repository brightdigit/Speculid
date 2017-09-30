//
//  ImageHandleBuilder.m
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import "ImageHandleBuilder.h"

ImageHandleBuilder * _shared = nil;

@implementation ImageHandleBuilder
+ (ImageHandleBuilder*) shared {
  if (_shared == nil) {
    _shared = [[ImageHandleBuilder alloc] init];
  }
  
  return _shared;
}
@end
