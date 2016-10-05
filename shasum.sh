#!/bin/sh
find "examples/Assets/." -name "*.spcld" -print0 |
while IFS= read -r -d $'\0' line; do
"./build/Build/Products/Release/Speculid.app/Contents/MacOS/Speculid" "$line" >/dev/null
done
wait
find "examples/Assets/." -type f \( -iname \*.icns -o -iname \*.png \) -print0 | sort -z | xargs -0 shasum -a 512 | shasum -a 512