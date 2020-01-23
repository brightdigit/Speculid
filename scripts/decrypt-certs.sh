#!/bin/sh

#  decrypt-certs.sh
#  Speculid
#
#  Created by Leo Dion on 10/26/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
mkdir -p tmp/certs
openssl aes-256-cbc -K $encrypted_3e2d534a03f2_key -iv $encrypted_3e2d534a03f2_iv -in certs/mac_development.p12.enc -out certs/mac_development.p12 -d
openssl aes-256-cbc -K $encrypted_3e2d534a03f2_key -iv $encrypted_3e2d534a03f2_iv -in certs/mac_development.cer.enc -out certs/mac_development.cer -d
openssl aes-256-cbc -K $APPLE_DEVELOPMENT_PASSWORD -iv $APPLE_DEVELOPMENT_PASSWORD -in certs/mac_development_20.p12.enc -out certs/mac_development_20.p12 -d
openssl aes-256-cbc -K $APPLE_DEVELOPMENT_PASSWORD -iv $APPLE_DEVELOPMENT_PASSWORD -in certs/mac_development_20.cer.enc -out certs/mac_development_20.cer -d
openssl aes-256-cbc -K $APPLE_DEVELOPMENT_PASSWORD -iv $encrypted_3e2d534a03f2_iv -in certs/development.cer.enc -out certs/development.cer -d
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/developer_id.p12.enc -d -a -out tmp/certs/developer_id.p12
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/developer_id.cer.enc -d -a -out tmp/certs/developer_id.cer
