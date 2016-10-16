#!/bin/sh
mkdir localCA/certs
cfssl gencert -initca localCA/ca-csr.json | cfssljson -bare localCA/certs/ca -
chmod 0600 localCA/certs/ca-key.pem
rm localCA/certs/ca.csr

openssl x509 -in localCA/certs/ca.pem -noout -text


