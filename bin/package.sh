#!/bin/bash

TEMP_AUTOREVISION_SH=`mktemp`

#BASE_URL=$1
#SAVE_APPCAST=$2
#BUILD_DIR=$3
#PUBLIC_SUBDIR=$4
#BUILD_PUBLIC="$3/${PUBLIC_SUBDIR}"

#ARCHIVE_PATH="${BUILD_DIR}/Speculid.xcarchive"
ZIP_PATH="${BUILD_DIR}/Speculid.zip"
APP_PATH=$1
#DSASIGNITURE_PATH="${BUILD_DIR}/dsaSigniture"

AUTOREVISION_JSON="frameworks/speculid/autorevision.json"
VERSIONS_PLIST="frameworks/speculid/versions.plist"

#ITEM_TEMPLATE_PATH="appcasts/item_template.xml"
#APPCASTS_PUBLIC="appcasts/public"

./bin/autorevision.sh -t sh >${TEMP_AUTOREVISION_SH} && source ${TEMP_AUTOREVISION_SH}
VCS_EXTRA=`perl -nle 'print $& if m{"VCS_EXTRA": "\K\d+}' ${AUTOREVISION_JSON}`

BUILD_NUMBER=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ${APP_PATH}/Contents/Info.plist`
VERSION_NUMBER=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ${APP_PATH}/Contents/Info.plist`
MINIMUM_PRODUCTION_BUILD=`/usr/libexec/PlistBuddy -c "Print :${VERSION_NUMBER}:production" ${VERSIONS_PLIST} 2>/dev/null`
MINIMUM_BETA_BUILD=`/usr/libexec/PlistBuddy -c "Print :${VERSION_NUMBER}:beta" ${VERSIONS_PLIST} 2>/dev/null`
MINIMUM_ALPHA_BUILD=`/usr/libexec/PlistBuddy -c "Print :${VERSION_NUMBER}:alpha" ${VERSIONS_PLIST} 2>/dev/null`
PUBDATE=`date -R`
#DSASIGNITURE=$(cat ${DSASIGNITURE_PATH})
#
#TEMP_APPCAST_XML=`mktemp`
#TEMP_APPCAST_DIR=`mktemp -d`
#
#echo $BUILD_NUMBER


if [[ $MINIMUM_ALPHA_BUILD =~ ^-?[0-9]+$ ]]; then
	if [ $MINIMUM_ALPHA_BUILD -le $BUILD_NUMBER ]; then
		MINIMUM_BUILD=$MINIMUM_ALPHA_BUILD
	fi
fi

if [[ $MINIMUM_BETA_BUILD =~ ^-?[0-9]+$ ]]; then
	if [ $MINIMUM_BETA_BUILD -le $BUILD_NUMBER ]; then
		BETA=1
		MINIMUM_BUILD=$MINIMUM_BETA_BUILD
	else
		BETA=0
	fi
fi

if [[ $MINIMUM_PRODUCTION_BUILD =~ ^-?[0-9]+$ ]]; then
	if [ $MINIMUM_PRODUCTION_BUILD -le $BUILD_NUMBER ]; then
		PRODUCTION=1
		MINIMUM_BUILD=$MINIMUM_PRODUCTION_BUILD
	else
		PRODUCTION=0
	fi
fi

#LONG_VERSION_NUMBER_SUFFIX=${BUILD_NUMBER_ZEROFILL}
#
if [[ $PRODUCTION -eq 1 ]]; then
  STAGE=10
elif [[ $BETA -eq 1 ]]; then
  STAGE=5
else
  STAGE=2
fi

#echo $MINIMUM_BUILD
#
if [[ $MINIMUM_BUILD ]]; then
  VERSION_SUFFIX=$(expr $BUILD_NUMBER - $MINIMUM_BUILD + 1)
else
  VERSION_SUFFIX=$BUILD_NUMBER
fi

if [ $STAGE -eq 10 ]; then
  SHORT_VERSION_NUMBER=${VERSION_NUMBER}
else
  if [ $STAGE -eq 5 ]; then
    STAGE_TEXT=beta
  elif [ $STAGE -eq 2 ]; then
    STAGE_TEXT=alpha
  else
    STAGE_TEXT=build
  fi
  SHORT_VERSION_NUMBER=${VERSION_NUMBER}-${STAGE_TEXT}${VERSION_SUFFIX}
fi



BUILD_NUMBER_ZEROFILL=$(printf %02d $VERSION_SUFFIX)
VCS_TICK_ZEROFILL=$(printf %04d $VCS_TICK)
VCS_EXTRA_ZEROFILL=$(printf %03d $VCS_EXTRA)
LONG_VERSION_NUMBER_SUFFIX=${VERSION_NUMBER}.${BUILD_NUMBER_ZEROFILL}${VCS_TICK_ZEROFILL}${VCS_EXTRA_ZEROFILL}
echo ${LONG_VERSION_NUMBER_SUFFIX}
echo ${SHORT_VERSION_NUMBER}

ditto -c -k --sequesterRsrc --keepParent ${APP_PATH} build/Speculid.${LONG_VERSION_NUMBER_SUFFIX}.zip
ditto -c -k --sequesterRsrc --keepParent ${APP_PATH} build/Speculid.${SHORT_VERSION_NUMBER}.zip
#FILENAME=releases/Speculid.${SHORT_VERSION_NUMBER}.zip
#
#APPCAST_XML_FILENAME=${SHORT_VERSION_NUMBER}.xml
#
##LONG_VERSION_NUMBER=${VERSION_NUMBER}.${LONG_VERSION_NUMBER_SUFFIX}
#FILE_LENGTH=`(
#  du --apparent-size --block-size=1 "${ZIP_PATH}" 2>/dev/null ||
#  gdu --apparent-size --block-size=1 "${ZIP_PATH}" 2>/dev/null ||
#  find "${ZIP_PATH}" -printf "%s" 2>/dev/null ||
#  gfind "${ZIP_PATH}" -printf "%s" 2>/dev/null ||
#  stat --printf="%s" "${ZIP_PATH}" 2>/dev/null ||
#  stat -f%z "${ZIP_PATH}" 2>/dev/null ||
#  wc -c <"${ZIP_PATH}" 2>/dev/null
#) | awk '{print $1}'`
#
#ITEM_TEMPLATE_STR=$(cat ${ITEM_TEMPLATE_PATH})
#eval "echo \"${ITEM_TEMPLATE_STR}\"" >${TEMP_APPCAST_XML}
#
#mkdir ${TEMP_APPCAST_DIR}/production
#mkdir ${TEMP_APPCAST_DIR}/beta
#mkdir ${TEMP_APPCAST_DIR}/alpha
#
#mkdir -p ${APPCASTS_PUBLIC}/production
#mkdir -p ${APPCASTS_PUBLIC}/beta
#mkdir -p ${APPCASTS_PUBLIC}/alpha
#mkdir -p ${BUILD_PUBLIC}/releases
#
#if [ "$SAVE_APPCAST" = true ]; then
#  if [ $STAGE -eq 10 ]; then
#    cp ${TEMP_APPCAST_XML}  ${APPCASTS_PUBLIC}/production/${APPCAST_XML_FILENAME}
#  elif [ $STAGE -ge 5 ]; then
#    cp ${TEMP_APPCAST_XML}  ${APPCASTS_PUBLIC}/beta/${APPCAST_XML_FILENAME}
#  elif [ $STAGE -ge 2 ]; then
#    cp ${TEMP_APPCAST_XML}  ${APPCASTS_PUBLIC}/alpha/${APPCAST_XML_FILENAME}
#  fi
#else
#  if [ $STAGE -eq 10 ]; then
#    cp ${TEMP_APPCAST_XML}  ${TEMP_APPCAST_DIR}/production/${APPCAST_XML_FILENAME}
#  fi
#
#  if [ $STAGE -ge 5 ]; then
#    cp ${TEMP_APPCAST_XML}  ${TEMP_APPCAST_DIR}/beta/${APPCAST_XML_FILENAME}
#  fi
#
#  if [ $STAGE -ge 2 ]; then
#    cp ${TEMP_APPCAST_XML}  ${TEMP_APPCAST_DIR}/alpha/${APPCAST_XML_FILENAME}
#  fi
#fi
#
#cp ${APPCASTS_PUBLIC}/production/*.xml ${TEMP_APPCAST_DIR}/production 2>/dev/null || :
#cp ${APPCASTS_PUBLIC}/production/*.xml ${TEMP_APPCAST_DIR}/beta 2>/dev/null || :
#cp ${APPCASTS_PUBLIC}/production/*.xml ${TEMP_APPCAST_DIR}/alpha 2>/dev/null || :
#cp ${APPCASTS_PUBLIC}/beta/${VERSION_NUMBER}*.xml ${TEMP_APPCAST_DIR}/beta 2>/dev/null || :
#cp ${APPCASTS_PUBLIC}/beta/${VERSION_NUMBER}*.xml ${TEMP_APPCAST_DIR}/alpha 2>/dev/null || :
#cp ${APPCASTS_PUBLIC}/alpha/${VERSION_NUMBER}*.xml ${TEMP_APPCAST_DIR}/alpha 2>/dev/null || :
#
#production_items=$(cat ${TEMP_APPCAST_DIR}/production/*.xml 2>/dev/null)
#beta_items=$(cat ${TEMP_APPCAST_DIR}/beta/*.xml 2>/dev/null)
#alpha_items=$(cat ${TEMP_APPCAST_DIR}/alpha/*.xml 2>/dev/null)
#
#template_str=$(cat "appcasts/appcast_template.xml")
#items=${production_items}
#eval "echo \"${template_str}\"" >"${BUILD_PUBLIC}/releases.xml"
#
#items=${beta_items}
#eval "echo \"${template_str}\"" >"${BUILD_PUBLIC}/beta.${VERSION_NUMBER}.xml"
#
#items=${alpha_items}
#eval "echo \"${template_str}\"" >"${BUILD_PUBLIC}/alpha.${VERSION_NUMBER}.xml"
#
#cp ${ZIP_PATH} ${BUILD_PUBLIC}/${FILENAME}
#
#rm -rf ${TEMP_APPCAST_DIR}

