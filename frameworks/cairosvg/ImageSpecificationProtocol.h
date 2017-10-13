//
//  ImageSpecification.h
//  SpeculidCairo
//
//  Created by Leo Dion on 9/30/17.
//

#import <Foundation/Foundation.h>
#import "GeometryDimension.h"
#import "CairoColorProtocol.h"
#import "ImageFileProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ImageSpecificationProtocol <NSObject>
@property (readonly) id<ImageFileProtocol> _Nonnull file;
@property (readonly) GeometryDimension geometry;
@property (readonly) BOOL removeAlphaChannel;
@property (readonly) id<CairoColorProtocol> _Nullable backgroundColor;
@end
NS_ASSUME_NONNULL_END
