//
//  GeometryDimension.h
//  Speculid-Mac-App
//
//  Created by Leo Dion on 10/12/17.
//  Copyright © 2017 Bright Digit, LLC. All rights reserved.
//

#ifndef GeometryDimension_h
#define GeometryDimension_h

#import "Dimension.h"

typedef struct GeometryDimension {
  CGFloat value;
  Dimension dimension;
} GeometryDimension;

extern const struct GeometryDimension GeometryDimensionUnspecified = {
  .value = 0,
  .dimension = kUnspecified
};
#endif /* GeometryDimension_h */
