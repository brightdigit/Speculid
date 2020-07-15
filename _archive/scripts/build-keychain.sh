#!/bin/sh

#  build-keychain.sh
#  Speculid
#
#  Created by Leo Dion on 10/26/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
# Create custom keychain
security create-keychain -p $CUSTOM_KEYCHAIN_PASSWORD macos-build.keychain

# Make the macos-build.keychain default, so xcodebuild will use it
security default-keychain -s macos-build.keychain

# Unlock the keychain
security unlock-keychain -p $CUSTOM_KEYCHAIN_PASSWORD macos-build.keychain

# Set keychain timeout to 3 hours for long builds
security set-keychain-settings -lut 7200 macos-build.keychain

security import ./certs/development.cer -k macos-build.keychain -A
security import ./certs/mac_development.p12 -k macos-build.keychain -P $CERTIFICATE_PASSWORD -A
security import ./certs/mac_development.cer -k macos-build.keychain -A
security import ./certs/mac_development_20.p12 -k macos-build.keychain -P $APPLE_DEVELOPMENT_PASSWORD -A
security import ./certs/mac_development_20.cer -k macos-build.keychain -A
security import ./tmp/certs/developer_id.p12 -k macos-build.keychain -P $CERTIFICATE_PASSWORD -A
security import ./tmp/certs/developer_id.cer -k macos-build.keychain -A

# Fix for OS X Sierra that hungs in the codesign step
security set-key-partition-list -S apple-tool:,apple: -s -k $CUSTOM_KEYCHAIN_PASSWORD macos-build.keychain
