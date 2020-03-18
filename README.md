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


## Check Certificate/Key Validity

Download the following files from the assests in [releases](https://github.com/IBM/cloud-pak-cli/releases):
- cloudctl.pem
- cloudctl-chain0.pem
- cloudctl-chain1.pem

#### Verify that the certificate/key is owned by IBM:

```
openssl x509 -inform pem -in cloudctl.pem -noout -text
```

#### Verify authenticity of certificate/key:

```
cat cloudctl-chain0.pem > chain.pem
cat cloudctl-chain1.pem >> chain.pem

openssl ocsp -no_nonce -issuer chain.pem -cert cloudctl.pem -VAfile chain.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains 

`Response verify OK`

## Optionallay Validate Each Certificate

#### Verify that the certificate is still active:

```
openssl ocsp -no_nonce -issuer cloudctl-chain0.pem -cert cloudctl.pem -VAfile cloudctl-chain0.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains 

`Response verify OK`

#### Verify that the intermediate certificate is still active:

```
openssl ocsp -no_nonce -issuer cloudctl-chain1.pem -cert cloudctl-chain0.pem -VAfile cloudctl-chain1.pem -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains 

`Response verify OK`


## Verify Binary

After completing verification of the certificate, extract public key:

```
openssl x509 -pubkey -noout -in cloudctl.pem > public.key
```

The public key is used to verify the binary:

```
openssl dgst -sha256 -verify public.key -signature <cloudctl_signature_file> <binary_file>
```

e.g.

```
openssl dgst -sha256 -verify public.key -signature cloudctl-darwin-amd64.sig cloudctl-darwin-amd64
```

Should see a message that contains 

`Verified OK`
