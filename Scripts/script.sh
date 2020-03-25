#!/bin/bash

SWIFT_VER="5.2"

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  swiftformat --lint . && swiftlint
elif [[ $TRAVIS_OS_NAME = 'linux' ]]; then
  # What to do in Ubunutu
  RELEASE_DOT=$(lsb_release -r)
  RELEASE_NUM=$(cut -f2 <<< "$RELEASE_DOT")
  export PATH="${PWD}/swift-${SWIFT_VER}-RELEASE-ubuntu${RELEASE_NUM}/usr/bin:$PATH"
fi

swift build
swift test  --enable-code-coverage

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  xcrun llvm-cov export -format="lcov" .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests -instr-profile .build/debug/codecov/default.profdata > info.lcov
  bash <(curl https://codecov.io/bash) -F travis -F macOS -n $TRAVIS_JOB_NUMBER-$TRAVIS_OS_NAME
else
  llvm-cov export -format="lcov" .build/x86_64-unknown-linux-gnu/debug/${FRAMEWORK_NAME}PackageTests.xctest -instr-profile .build/debug/codecov/default.profdata > info.lcov
  bash <(curl https://codecov.io/bash) -F travis -F bionic -n $TRAVIS_JOB_NUMBER-$TRAVIS_OS_NAME
fi

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  swift package dump-package | jq -e ".products | length > 0"
  pod lib lint
  swift package generate-xcodeproj
  pod install --project-directory=Example
  xcodebuild -workspace Example/Example.xcworkspace -scheme "iOS_Example"  ONLY_ACTIVE_ARCH=NO  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO
  xcodebuild -workspace Example/Example.xcworkspace -scheme "tvOS_Example"  ONLY_ACTIVE_ARCH=NO   CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO
  xcodebuild -workspace Example/Example.xcworkspace -scheme "macOS_Example"  ONLY_ACTIVE_ARCH=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO  CODE_SIGNING_ALLOWED=NO
fi
