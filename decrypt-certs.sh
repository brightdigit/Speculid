#!/bin/sh

#  decrypt-certs.sh
#  Speculid
#
#  Created by Leo Dion on 10/26/17.
#  Copyright © 2017 Bright Digit, LLC. All rights reserved.
mkdir -p tmp/certs
#openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_app-cert.cer.enc -d -a -out tmp/certs/mac_app-cert.cer
#openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_development-key.p12.enc -d -a -out tmp/certs/mac_development-key.p12
#openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/mac_development-cert.cer.enc -d -a -out tmp/certs/mac_development-cert.cer
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/mac_developer.p12.enc -d -a -out tmp/certs/mac_developer.p12
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/mac_developer.cer.enc -d -a -out tmp/certs/mac_developer.cer
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/developer_id.p12.enc -d -a -out tmp/certs/developer_id.p12
openssl aes-256-cbc -k "$CERTIFICATE_PASSWORD" -in certs/developer_id.cer.enc -d -a -out tmp/certs/developer_id.cer
#openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/3rd_party_mac_development-key.p12.enc -d -a -out tmp/certs/3rd_party_mac_development-key.p12
#openssl aes-256-cbc -k "$SECURITY_PASSWORD" -in certs/3rd_party_mac_development-cert.cer.enc -d -a -out tmp/certs/3rd_party_mac_development-cert.cer
