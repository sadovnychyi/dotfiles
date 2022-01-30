#!/usr/bin/env bash

# https://letsencrypt.org/docs/certificates-for-localhost/
# This will create a certificate for "localhost".
openssl req -x509 -out ~/.localhost.crt -keyout ~/.localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -days 999 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
# Mark created certificate as "trusted" on this machine.
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.localhost.crt
brew services restart nginx
