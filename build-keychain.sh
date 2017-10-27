#!/bin/sh

#  build-keychain.sh
#  Speculid
#
#  Created by Leo Dion on 10/26/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
# Create custom keychain
security create-keychain -p $CUSTOM_KEYCHAIN_PASSWORD macos-build.keychain
# Make the ios-build.keychain default, so xcodebuild will use it
security default-keychain -s macos-build.keychain
# Unlock the keychain
security unlock-keychain -p $CUSTOM_KEYCHAIN_PASSWORD macos-build.keychain
# Set keychain timeout to 1 hour for long builds
# see here
security set-keychain-settings -t 3600 -l ~/Library/Keychains/macos-build.keychain

security import ./certs/AppleWWDRCA.cer -k macos-build.keychain -A
security import ./tmp/certs/mac_app-cert.cer -k macos-build.keychain -A
security import ./tmp/certs/mac_development-key.p12 -k macos-build.keychain -P $SECURITY_PASSWORD -A
security import ./tmp/certs/mac_development-cert.cer -k macos-build.keychain -A
# Fix for OS X Sierra that hungs in the codesign step
security set-key-partition-list -S apple-tool:,apple: -s -k $SECURITY_PASSWORD macos-build.keychain > /dev/null
