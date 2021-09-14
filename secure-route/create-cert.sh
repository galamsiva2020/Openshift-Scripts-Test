#!/bin/bash

echo "Generating a private key..."
openssl genrsa -out hello.apps.lab.example.com.key 2048
echo

echo "Generating a CSR..."
openssl req -new -key hello.apps.lab.example.com.key -out hello.apps.lab.example.com.csr -subj "/C=US/ST=NC/L=Raleigh/O=RedHat/OU=RHT/CN=hello.apps.lab.example.com"
echo

echo "Generating a certificate..."
openssl x509 -req -days 366 -in hello.apps.lab.example.com.csr -signkey hello.apps.lab.example.com.key -out hello.apps.lab.example.com.crt
echo
echo  "DONE."
echo
