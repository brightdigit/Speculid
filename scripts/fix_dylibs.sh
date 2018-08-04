#!/bin/sh

LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
for lib in $LIBS; do
  echo $lib
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
#   dylib="`dirname $1`/Frameworks/`basename $lib`"
#   deps=`otool -L "$dylib" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
#   for dependency in $DEPS; do
#     echo "Fixing $dependency"
#     install_name_tool -id @rpath/`basename $dependency` "$dylib"
#     install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
# #DEPCOUNT=$((DEPCOUNT+1))
# done
done

FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
deps=`ls "$FRAMEWORKS_FOLDER_PATH" | awk -F' ' '{ print $1 }'`
for lib in $deps; do
  echo "Fixing $dependency"
#   install_name_tool -id @rpath/`basename $dependency` "$dylib"
#   install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
# #DEPCOUNT=$((DEPCOUNT+1))
echo $lib
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
  dylib="`dirname $1`/Frameworks/`basename $lib`"
  deps=`otool -L "$dylib" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
  for dependency in $deps; do
      echo "Fixing $dependency"
#install_name_tool -id @rpath/`basename $dependency` "$dylib"
      install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
#DEPCOUNT=$((DEPCOUNT+1))
    done
done
##
###  fix_dylibs.sh
###  speculid
###
###  Created by Leo Dion on 11/27/17.
###  Copyright © 2017 Bright Digit, LLC. All rights reserved.
##
#
#for (( c=1; c<=10; c++ ))
#do
#  echo "Iteration: $c"
#  DEPCOUNT=0
#  DYLIBS=`ls "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"`
#  for dylib in $DYLIBS; do
#otool -L "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib"
#    DEPS=`otool -L "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
#
##    for dependency in $DEPS; do
##   echo "Installing $dependency"
##install -m 755 $dependency "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"
#
##    done
#    for dependency in $DEPS; do
#      echo "Fixing $dependency"
#      install_name_tool -id @rpath/`basename $dependency` "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib"
#      install_name_tool -change $dependency @rpath/`basename $dependency` "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$dylib"
#      DEPCOUNT=$((DEPCOUNT+1))
#    done
#  done
#  echo "Dependency Count: $DEPCOUNT"
#  if [ $DEPCOUNT -eq 0 ]; then exit; fi
#done
#
#
#DEPS=`otool -L "$TARGET" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
#for dependency in $DEPS; do
#  echo "Installing $dependency"
##  install -m 755 $dependency "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH"
#  install_name_tool -id @rpath/`basename $dependency` "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/`basename $dependency`"
#  install_name_tool -change $dependency @rpath/`basename $dependency` "$BUILT_PRODUCTS_DIR/$EXECUTABLE_PATH"
#  otool -L "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/`basename $dependency`"
#  BASENAME=`basename $dependency`
##  SUBDEPS=`otool -L "$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/$BASENAME" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
##  for subdependency in $SUBDEPS; do
##    echo "Installing `basename $subdependency` for $BASENAME"
##    install_name_tool -id @rpath/`basename $subdependency` "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/`basename $subdependency`"
##    install_name_tool -change $dependency @rpath/`basename $subdependency` "$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/$BASENAME"
##  done
#
#done
