#!/bin/sh
export PATH=/usr/local/bin:$PATH

cd Speculid

source ~/.bash_profile

rbenv install
rbenv local

gem install bundler

bundle install

rbenv rehash

pod repo update

pod install

