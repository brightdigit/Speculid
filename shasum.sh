#!/bin/bash

speculid_path=${1:-./build/Build/Products/Release/Speculid.app/Contents/MacOS/Speculid}
assets_dir=${2:-examples/Assets/.}

find $assets_dir -name "*.spcld" -print0 |
while IFS= read -r -d $'\0' line; do
 $speculid_path "$line" >/dev/null
done
wait
find $assets_dir -type f \( -iname \*.icns -o -iname \*.png \) -print0 | sort -z | xargs -0 shasum -a 512 | shasum -a 512