# Overview
Cloudctl is a command line tool to manage Container Application Software for Enterprises (CASE)


## Download and Install

1. Download either the zip or tar archives from the assets in [releases](https://github.com/IBM/cloud-pak-cli/releases)
2. Extract the archive
    - `unzip <archive-name>`
    - `tar -xzf <archive-name>`

There should be two files after extraction:
- cloudctl binary (e.g. cloudctl-darwin-amd64)
- cloudctl signature (e.g. cloudctl-darwin-amd64.sig)

The signature file is used for verification purposes


## Check Certificate Validity

Download the following files from the assests in [releases](https://github.com/IBM/cloud-pak-cli/releases):
- cloudctl_cert.pub
- cloudctl_cert_chain0.pub
- cloudctl_cert_chain1.pub

Verify that the certificate is owned by IBM:

`openssl x509 -inform pem -in cloudctl_cert.pub -noout -text`

Verify that the certificate is still active:

`openssl ocsp -no_nonce -issuer cloudctl_cert_chain0.pub -cert cloudctl_cert.pub -VAfile cloudctl_cert_chain0.pub -text -url http://ocsp.digicert.com -respout ocsptest`

Should see a message that contains 

`Response verify OK`

Verify that the intermediate certificate is still active:

`openssl ocsp -no_nonce -issuer cloudctl_cert_chain1.pub -cert cloudctl_cert_chain0.pub -VAfile cloudctl_cert_chain1.pub -text -url http://ocsp.digicert.com -respout ocsptest`

Should see a message that contains 

`Response verify OK`


## Verify Binary

Download the following file from the assests in [releases](https://github.com/IBM/cloud-pak-cli/releases):
- cloudctl_key.pub

Verify the binary:

`openssl dgst -sha256 -verify cloudctl_key.pub -signature <cloudctl_signature_file> <binary_file>`

e.g.

`openssl dgst -sha256 -verify cloudctl_key.pub -signature cloudctl-darwin-amd64.sig cloudctl-darwin-amd64`

Should see a message that contains 

`Verified OK`
