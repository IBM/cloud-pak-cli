<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Download public keys](#download-public-keys)
- [Check Certificate/Key Validity and Archives](#check-certificatekey-validity-and-archives)
  - [Check Certificate/Key Validity](#check-certificatekey-validity)
    - [Verify that the certificate/key is owned by IBM:](#verify-that-the-certificatekey-is-owned-by-ibm)
    - [Verify authenticity of certificate/key:](#verify-authenticity-of-certificatekey)
  - [Optionally Compare the certificate and the public key](#optionally-compare-the-certificate-and-the-public-key)
    - [Check public key details](#check-public-key-details)
    - [Check certficate details](#check-certficate-details)
  - [Verify Archive](#verify-archive)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Download public keys

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/certificates/cloudctl.pem.cer -o cloudctl.pem.cer
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/certificates/cloudctl.pem.chain -o cloudctl.pem.chain
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/certificates/cloudctl.pem.pub.key -o cloudctl.pem.pub.key
```

# Check Certificate/Key Validity and Archives

## Check Certificate/Key Validity

### Verify that the certificate/key is owned by IBM:
Note: On windows, run below commands from Git Bash

```
openssl x509 -inform pem -in cloudctl.pem.cer -noout -text
```

### Verify authenticity of certificate/key:

```
openssl ocsp -no_nonce -issuer cloudctl.pem.chain -cert cloudctl.pem.cer -VAfile cloudctl.pem.chain -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

## Optionally Compare the certificate and the public key

### Check public key details

```
openssl rsa -noout -text -inform PEM -in cloudctl.pem.pub.key -pubin
```

Make a note of modulus and Exponent

### Check certficate details

```
openssl x509 -inform pem -in cloudctl.pem.cer -noout -text
```

Check the `Public-Key` section in the output and compare with previous result.


## Verify Archive

We will verify cloudctl-linux-amd64.tar.gz. Steps will be same for other archives.

Convert the signature from base64 to bytes

```
export ARCHIVE=cloudctl-linux-amd64.tar.gz
openssl enc -d -A -base64 -in "${ARCHIVE}.sig" -out "/tmp/${ARCHIVE}.decoded.sig"
```

Verify the signature bytes:

```
export ARCHIVE=cloudctl-linux-amd64.tar.gz
openssl dgst -verify cloudctl.pem.pub.key -keyform PEM -sha256 -signature "/tmp/${ARCHIVE}.decoded.sig" -binary "${ARCHIVE}"
```