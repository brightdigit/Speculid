#!/bin/sh

#  fix_dylibs.sh
#  speculid
#
#  Created by Leo Dion on 11/27/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
for (( c=1; c<=10; c++ ))
do
echo "Iteration: $c"
  DYLIBS=`ls "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"`
  for dylib in $DYLIBS; do
    DEPS=`otool -L "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib" | grep "/opt" | awk -F' ' '{ print $1 }'`

    echo "Dep Count: ${#DEPS[@]}"
    for dependency in $DEPS; do
    echo "Installing $dependency"
    install -m 755 $dependency "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"

    done
    for dependency in $DEPS; do
      echo "Fixing $dependency"
      install_name_tool -id @rpath/`basename $dependency` "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib"
      install_name_tool -change $dependency @rpath/`basename $dependency` "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib"
    done
  done
done


