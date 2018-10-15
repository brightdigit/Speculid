#!/bin/sh

export PATH=/usr/local/bin:$PATH

cd Speculid

source ~/.bash_profile

rbenv local

gem uninstall -aIx

brew bundle cleanup --global

