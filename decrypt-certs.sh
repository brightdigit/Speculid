#!/bin/sh

#  decrypt-certs.sh
#  Speculid
#
#  Created by Leo Dion on 10/26/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
mkdir -p tmp/certs
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_app-cert.cer.enc -d -a -out tmp/certs/mac_app-cert.cer
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_development-cert.cer.enc -d -a -out tmp/certs/mac_development-cert.cer
openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_development-key.p12.enc -d -a -out tmp/certs/mac_development-key.p12
