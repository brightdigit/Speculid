#!/bin/sh

FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
for lib in $LIBS; do
  EXPECTED_PATH="`dirname $1`/Frameworks/`basename $lib`"
  if [ ! -f $EXPECTED_PATH ]; then
  IFS='.' read -ra FILENAME_COMPS <<< "`basename $lib`"
  ACTUAL_PATH=`find $FRAMEWORKS_FOLDER_PATH -name "${FILENAME_COMPS[0]}*.*"`
  install_name_tool -id @rpath/`basename $ACTUAL_PATH` "`dirname $1`/Frameworks/`basename $ACTUAL_PATH`"
  install_name_tool -change $lib @rpath/`basename $ACTUAL_PATH` "$1"
  echo "Fixing `basename $lib` (`basename $ACTUAL_PATH`) for Framework"
  else
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
  echo "Fixing `basename $lib` for Framework"
  fi
done

deps=`ls "$FRAMEWORKS_FOLDER_PATH" | awk -F' ' '{ print $1 }'`
for lib in $deps; do
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
  dylib="`dirname $1`/Frameworks/`basename $lib`"
  deps=`otool -L "$dylib" | grep "/opt\|Cellar\|loader_path" | awk -F' ' '{ print $1 }'`
  for dependency in $deps; do
      EXPECTED_PATH="`dirname $1`/Frameworks/`basename $dependency`"
      if [ ! -f $EXPECTED_PATH ]; then
      IFS='.' read -ra FILENAME_COMPS <<< "`basename $dependency`"
      ACTUAL_PATH=`find $FRAMEWORKS_FOLDER_PATH -name "${FILENAME_COMPS[0]}*.*"`
      install_name_tool -change $dependency @rpath/`basename $ACTUAL_PATH` "$dylib"
      echo "Fixing `basename $dependency` (`basename $ACTUAL_PATH`) for `basename $dylib`"
      else
      install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
      echo "Fixing `basename $dependency` for `basename $dylib`"
      fi
    done
done
	
