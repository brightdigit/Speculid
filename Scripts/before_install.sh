#!/bin/bash

if [[ $TRAVIS_OS_NAME = 'osx' ]]; then
  brew update
  brew bundle
else
  wget https://swift.org/builds/swift-5.1.3-release/ubuntu1804/swift-5.1.3-RELEASE/swift-5.1.3-RELEASE-ubuntu18.04.tar.gz
  tar xzf swift-5.1.3-RELEASE-ubuntu18.04.tar.gz
  ls ${PWD}/swift-5.1.3-RELEASE-ubuntu18.04/usr/bin
  export PATH="${PWD}/swift-5.1.3-RELEASE-ubuntu18.04/usr/bin:$PATH"
fi