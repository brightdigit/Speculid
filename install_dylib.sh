#!/bin/sh

#  install_dylib.sh
#  Speculid
#
#  Created by Leo Dion on 10/24/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.

DYLIB=$(basename $1)

mkdir -p "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"

cp -f $1 "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"

install_name_tool -change $1 "@rpath/$DYLIB" "$TARGET_BUILD_DIR/$EXECUTABLE_PATH"

echo "Installing $DYLIB to $FRAMEWORKS_FOLDER_PATH/$DYLIB"
