#!/bin/sh

#  setup-dependencies.sh
#  speculid
#
#  Created by Leo Dion on 12/9/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
OTHER_CFLAGS="$(pkg-config cairo librsvg-2.0  --cflags)"
OTHER_LDFLAGS="$(pkg-config cairo librsvg-2.0  --libs)"
HEADER_SEARCH_PATHS="$(pkg-config --cflags-only-I cairo librsvg-2.0 | tr -d '\-I')"
echo "OTHER_CFLAGS = \$(inherited) ${OTHER_CFLAGS}" > CairoSVG.xcconfig
echo "OTHER_LDFLAGS = \$(inherited) ${OTHER_LDFLAGS}" >> CairoSVG.xcconfig
echo "HEADER_SEARCH_PATHS = \$(inherited) ${HEADER_SEARCH_PATHS}" >> CairoSVG.xcconfig
