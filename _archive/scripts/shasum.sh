#!/bin/bash

speculid_path=${1:-./Build/Products/App/Speculid.app/Contents/SharedSupport/speculid --useLocation ./build/Products/App/Speculid.app}
assets_dir=${2:-examples/Assets/.}

find $assets_dir -name "*.speculid" -print0 |
while IFS= read -r -d $'\0' line; do
 $speculid_path --process "$line" >/dev/null
done
wait
(cd $assets_dir && find . -type f \( -iname \*.icns -o -iname \*.png \) -print0 | sort -z | xargs -0 shasum -a 512 | shasum -a 512)
