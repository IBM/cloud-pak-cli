<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Download public keys](#download-public-keys)
- [Check Certificate/Key Validity and Archives](#check-certificatekey-validity-and-archives)
  - [Check Certificate/Key Validity](#check-certificatekey-validity)
      - [Verify that the certificate/key is owned by IBM:](#verify-that-the-certificatekey-is-owned-by-ibm)
      - [Verify authenticity of certificate/key:](#verify-authenticity-of-certificatekey)
  - [Optionally Validate Each Certificate Individually](#optionally-validate-each-certificate-individually)
      - [Verify that the certificate is still active:](#verify-that-the-certificate-is-still-active)
      - [Verify that the intermediate certificate is still active:](#verify-that-the-intermediate-certificate-is-still-active)
  - [Verify Archive](#verify-archive)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Download public keys

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl.pub
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl-chain0.pub
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl-chain1.pub
```

# Check Certificate/Key Validity and Archives

## Check Certificate/Key Validity

#### Verify that the certificate/key is owned by IBM:

```
openssl x509 -inform pem -in cloudctl.pub -noout -text
```

#### Verify authenticity of certificate/key:

```
cat cloudctl-chain0.pub > chain.pub
cat cloudctl-chain1.pub >> chain.pub

openssl ocsp -no_nonce -issuer chain.pub -cert cloudctl.pub -VAfile chain.pub -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

## Optionally Validate Each Certificate Individually

#### Verify that the certificate is still active:

```
openssl ocsp -no_nonce -issuer cloudctl-chain0.pub -cert cloudctl.pub -VAfile cloudctl-chain0.pub -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

#### Verify that the intermediate certificate is still active:

```
openssl ocsp -no_nonce -issuer cloudctl-chain1.pub -cert cloudctl-chain0.pub -VAfile cloudctl-chain1.pub -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`


## Verify Archive

After completing verification of the certificate, extract public key:

```
openssl x509 -pubkey -noout -in cloudctl.pub > public.key
```

The public key is used to verify the tar archive:

```
openssl dgst -sha256 -verify public.key -signature <cloudctl_signature_file> <tar.gz_file>
```

e.g.

```
openssl dgst -sha256 -verify public.key -signature cloudctl-darwin-amd64.tar.gz.sig cloudctl-darwin-amd64.tar.gz
```

Should see a message that contains:

`Verified OK`