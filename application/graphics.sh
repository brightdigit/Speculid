#!/bin/bash

PACKS=./graphics/packs/active/
ASSET_ROOT=./Media.xcassets/Icons/Packs
if [ ! -d "$ASSET_ROOT" ]; then
  rm -rf $ASSET_ROOT
  mkdir -p $ASSET_ROOT
  echo '{"info":{"version":1,"author":"xcode"}}' > $ASSET_ROOT/Contents.json
  for pack in "$PACKS"*
  do
    packname=$(basename "$pack")
    mkdir -p $ASSET_ROOT/$packname
    echo '{"info":{"version":1,"author":"xcode"}}' > $ASSET_ROOT/$packname/Contents.json
    for file in $pack/*.svg
    do
      imagename=$(basename "$file" ".svg")
      mkdir -p $ASSET_ROOT/$packname/$imagename-$packname.imageset
      echo '{"images":[{"idiom":"universal","filename":"icon.pdf"}],"info":{"version":1,"author":"xcode"}}' > $ASSET_ROOT/$packname/$imagename-$packname.imageset/Contents.json
      inkscape --without-gui --export-area-drawing --export-pdf $ASSET_ROOT/$packname/$imagename-$packname.imageset/icon.pdf $file 2> /dev/null > /dev/null  &
    done
  done
  wait
fi

for x in 20 29 40 58 60 76 87 80 120 152 167 180 ; do inkscape --export-id=Release --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg 2> /dev/null > /dev/null  & done
wait
for x in 40 58 80 120 ; do cp -v Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}-1.png >/dev/null 2> /dev/null > /dev/null   & done
wait
for x in 40 ; do cp -v Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Production-Release.appiconset/appicon_${x}-2.png >/dev/null 2> /dev/null > /dev/null   & done
wait

for x in 20 29 40 58 60 76 87 80 120 152 167 180 ; do inkscape --export-id=alpha  --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Alpha-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg 2> /dev/null > /dev/null & done
wait
for x in 40 58 80 120 ; do cp -v Media.xcassets/AppIcon-Alpha-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Alpha-Release.appiconset/appicon_${x}-1.png 2> /dev/null > /dev/null    & done
wait
for x in 40 ; do cp -v Media.xcassets/AppIcon-Alpha-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Alpha-Release.appiconset/appicon_${x}-2.png 2> /dev/null > /dev/null   & done
wait


for x in 20 29 40 58 60 76 87 80 120 152 167 180 ; do inkscape --export-id=beta  --export-id-only --without-gui --export-png Media.xcassets/AppIcon-Beta-Release.appiconset/appicon_${x}.png -w ${x} -b white graphics/logo.svg 2> /dev/null > /dev/null & done
wait
for x in 40 58 80 120 ; do cp -v Media.xcassets/AppIcon-Beta-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Beta-Release.appiconset/appicon_${x}-1.png 2> /dev/null > /dev/null    & done
wait
for x in 40 ; do cp -v Media.xcassets/AppIcon-Beta-Release.appiconset/appicon_${x}.png Media.xcassets/AppIcon-Beta-Release.appiconset/appicon_${x}-2.png 2> /dev/null > /dev/null   & done
wait

MEDIA_ROOT=./Media.xcassets/
for appiconset in "$MEDIA_ROOT"*-Release.appiconset
do
  BASENAME=$(basename "$appiconset" .appiconset)
  STAGENAME=${BASENAME%-Release}
  DEBUGNAME="$MEDIA_ROOT$STAGENAME-Debug.appiconset"
  for SOURCE in $appiconset/*.png
  do
    BASENAME=$(basename "$SOURCE")
    DESTINATION=$DEBUGNAME/$BASENAME
    convert $SOURCE -posterize 5 -edge 1 -negate -monochrome $DESTINATION &
  done
  wait
done

inkscape --without-gui --export-area-drawing --export-pdf Media.xcassets/Title.imageset/title.pdf graphics/title.svg 2> /dev/null > /dev/null 
inkscape --without-gui --export-area-drawing --export-id=_x35_d85d3c3-4443-4929-9938-b4c08b4e3c05 --export-pdf Media.xcassets/Logo.imageset/logo.pdf graphics/logo.svg 2> /dev/null > /dev/null 
mkdir -p .tmp && sed -e "s/#FFFFFF/#000000/" graphics/logo.svg>.tmp/logo.svg && inkscape --without-gui --export-area-drawing --export-id=_x35_d85d3c3-4443-4929-9938-b4c08b4e3c05 --export-pdf Media.xcassets/Logo-Black.imageset/logo.pdf .tmp/logo.svg 2> /dev/null > /dev/null 


for x in 640 1280 1920 ; do convert graphics/pexels-photo.jpg -resize ${x} Media.xcassets/Backgrounds/Wrist-Watch.imageset/Write-Watch_${x}.jpg 2> /dev/null > /dev/null  & done
wait

for x in 640 1280 1920 ; do convert graphics/permissions/calendar.jpg -resize ${x} Media.xcassets/Backgrounds/Permissions/Calendar.imageset/Calendar_${x}.jpg 2> /dev/null > /dev/null & done
wait

for x in 640 1280 1920 ; do convert graphics/permissions/locations.jpg -resize ${x} Media.xcassets/Backgrounds/Permissions/Locations.imageset/Locations_${x}.jpg 2> /dev/null > /dev/null & done
wait

for x in 640 1280 1920 ; do convert graphics/permissions/notifications.jpg -resize ${x} Media.xcassets/Backgrounds/Permissions/Notifications.imageset/Notifications_${x}.jpg 2> /dev/null > /dev/null & done
wait

inkscape --without-gui --export-area-drawing --export-pdf Media.xcassets/Icons/Permissions/Notifications\ Icon.imageset/Notifications.pdf graphics/permissions/icons/notifications.svg 2> /dev/null > /dev/null 
inkscape --without-gui --export-area-drawing --export-pdf Media.xcassets/Icons/Permissions/Calendar\ Icon.imageset/Calendar.pdf graphics/permissions/icons/calendar.svg 2> /dev/null > /dev/null 
inkscape --without-gui --export-area-drawing --export-pdf Media.xcassets/Icons/Permissions/Locations\ Icon.imageset/Locations.pdf graphics/permissions/icons/locations.svg 2> /dev/null > /dev/null 

