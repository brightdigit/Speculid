#!/bin/sh

LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
for lib in $LIBS; do
  install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
  install_name_tool -change $lib @rpath/`basename $lib` "$1"
done

FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
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
      fi
    done
done
	

#!/bin/sh
#hashtable=$(mktemp -d)
#FRAMEWORK_DIR="`dirname $1`/Frameworks"
#LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
#for lib in $LIBS; do
#  LIB_BASENAME=`basename $lib`
#  EXPECTED_PATH="`dirname $1`/Frameworks/`basename $lib`"
#  if [ ! -f $EXPECTED_PATH ]; then
#    IFS='.' read -ra FILENAME_COMPS <<< "$LIB_BASENAME"
#    ACTUAL_PATH=`find $FRAMEWORK_DIR -name "${FILENAME_COMPS[0]}*.*"`
#    echo "Fixing `basename $lib` (`basename $ACTUAL_PATH`) for Framework"
#    install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $ACTUAL_PATH`"
#    install_name_tool -change $lib @rpath/`basename $ACTUAL_PATH` "$1"
#    echo `basename $ACTUAL_PATH` > $hashtable/$LIB_BASENAME
#  else
#    install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
#    install_name_tool -change $lib @rpath/`basename $lib` "$1"
#  fi
#done
#
#FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
#deps=`ls "$FRAMEWORKS_FOLDER_PATH" | awk -F' ' '{ print $1 }'`
#for lib in $deps; do
#  dylib="`dirname $1`/Frameworks/`basename $lib`"
#  echo "Fixing `basename $lib` for Framework"
#  install_name_tool -id @rpath/`basename $lib` "$dylib"
##install_name_tool -change $lib @rpath/`basename $lib` "$1"
#  deps=`otool -L "$dylib" | grep "/opt\|Cellar\|@loader_path" | awk -F' ' '{ print $1 }'`
#  for dependency in $deps; do
#    EXPECTED_PATH="`dirname $1`/Frameworks/`basename $dependency`"
#    if [ ! -f $EXPECTED_PATH ]; then
#      echo "Not Found! `basename $dependency`"
#      if [ ! -f $hashtable/`basename $dependency` ]; then
#        IFS='.' read -ra FILENAME_COMPS <<< "`basename $dependency`"
#        ACTUAL_PATH=`find $FRAMEWORK_DIR -name "${FILENAME_COMPS[0]}*.*"`
##install_name_tool -id @rpath/`basename $ACTUAL_PATH` "$dylib"
#        install_name_tool -change $dependency @rpath/`basename $ACTUAL_PATH` "$dylib"
#        echo "Fixing `basename $dependency` (`basename $ACTUAL_PATH`) for `basename $lib`"
#      else
#        ACTUAL_NAME=$(< $hashtable/`basename $dependency`)
##install_name_tool -id @rpath/$ACTUAL_NAME "$dylib"
#        install_name_tool -change $dependency @rpath/$ACTUAL_NAME "$dylib"
#        echo "Fixing `basename $dependency` ($ACTUAL_NAME) for `basename $lib`"
#      fi
#    else
#      install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
##name=$(< $hashtable/$`basename $dependency`)
#      echo "Fixing `basename $dependency` for `basename $lib`"
#    fi
#  done
#done
#
#FRAMEWORKS_FOLDER_PATH="`dirname $1`/Frameworks/"
#LIBS=`otool -L "$1" | grep "/opt\|Cellar" | awk -F' ' '{ print $1 }'`
#for lib in $LIBS; do
#LIB_BASENAME=`basename $lib`
#EXPECTED_PATH="`dirname $1`/Frameworks/`basename $lib`"
#if [ ! -f $EXPECTED_PATH ]; then
#IFS='.' read -ra FILENAME_COMPS <<< "$LIB_BASENAME"
#ACTUAL_PATH=`find $FRAMEWORKS_FOLDER_PATH -name "${FILENAME_COMPS[0]}*.*"`
#echo "Fixing `basename $lib` (`basename $ACTUAL_PATH`) for Framework"
#install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $ACTUAL_PATH`"
#install_name_tool -change $lib @rpath/`basename $ACTUAL_PATH` "$1"
##echo `basename $ACTUAL_PATH` > $hashtable/$LIB_BASENAME
#else
#install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
#install_name_tool -change $lib @rpath/`basename $lib` "$1"
#fi
#
#done
#
#deps=`ls "$FRAMEWORKS_FOLDER_PATH" | awk -F' ' '{ print $1 }'`
#for lib in $deps; do
##install_name_tool -id @rpath/`basename $lib` "`dirname $1`/Frameworks/`basename $lib`"
#install_name_tool -change $lib @rpath/`basename $lib` "$1"
#dylib="`dirname $1`/Frameworks/`basename $lib`"
#deps=`otool -L "$dylib" | grep "/opt\|Cellar\|loader_path" | awk -F' ' '{ print $1 }'`
#for dependency in $deps; do
#EXPECTED_PATH="`dirname $1`/Frameworks/`basename $dependency`"
#if [ ! -f $EXPECTED_PATH ]; then
#IFS='.' read -ra FILENAME_COMPS <<< "`basename $dependency`"
#ACTUAL_PATH=`find $FRAMEWORKS_FOLDER_PATH -name "${FILENAME_COMPS[0]}*.*"`
#install_name_tool -change $dependency @rpath/`basename $ACTUAL_PATH` "$dylib"
#echo "Fixing `basename $dependency` (`basename $ACTUAL_PATH`) for `basename $dylib`"
#else
#install_name_tool -change $dependency @rpath/`basename $dependency` "$dylib"
#fi
#done
#done
#
#
