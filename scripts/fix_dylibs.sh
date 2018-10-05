#!/bin/sh

LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
for lib in $LIBS; do
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
done

FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
deps=`ls "$FRAMEWORKS_FOLDER_PATH" | awk -F' ' '{ print $1 }'`
for lib in $deps; do
  echo "Fixing $dependency"
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
  dylib="`dirname $1`/Frameworks/`basename $lib`"
  deps=`otool -L "$dylib" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
  for dependency in $deps; do
      install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
    done
done
