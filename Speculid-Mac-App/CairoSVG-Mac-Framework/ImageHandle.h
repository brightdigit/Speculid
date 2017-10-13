//
//  ImageHandle.h
//  SpecCarioInterop
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>

typedef struct _cairo cairo_t;

NS_ASSUME_NONNULL_BEGIN
@protocol ImageHandle <NSObject>
-(CGSize) size;
-(BOOL) paintTo:(cairo_t*) renderer;
@end
NS_ASSUME_NONNULL_END
