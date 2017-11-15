#!/bin/sh

#  build.sh
#  Speculid
#
#  Created by Leo Dion on 11/14/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
#brew update
brew install librsvg cairo
#pod repo update
pod install
xcodebuild -workspace speculid.xcworkspace -scheme "CairoSVG-Flags" -derivedDataPath build  build -configuration "Debug"
xcodebuild archive -workspace speculid.xcworkspace -scheme "Speculid-Mac-App" -configuration Debug -derivedDataPath ./build -archivePath ./build/Products/Speculid.xcarchive
xcodebuild -exportArchive -archivePath ./build/Products/Speculid.xcarchive -exportOptionsPlist exportOptions.plist -exportPath ./build/Products/App
ditto -c -k --sequesterRsrc --keepParent ./build/Products/App/Speculid.app build/Speculid.zip
brew remove --ignore-dependencies librsvg cairo
open Build/Products/App/Speculid.app
