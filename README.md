# Overview
Cloudctl is a command line tool to manage Container Application Software for Enterprises (CASEs) 


## Download

1. Download the gzipped tar archive for your OS from the assets in [releases](https://github.com/IBM/cloud-pak-cli/releases)
2. Download the corresponding `.sig` file for verification purposes

Example using `curl`:
```
curl -L https://github.com/IBM/cloud-pak-cli/releases/download/v3.3.0/cloudctl-darwin-amd64.tar.gz -o cloudctl-darwin-amd64.tar.gz
curl -L https://github.com/IBM/cloud-pak-cli/releases/download/v3.3.0/cloudctl-darwin-amd64.tar.gz.sig -o cloudctl-darwin-amd64.tar.gz.sig
```

Example using `wget`:
```
wget https://github.com/IBM/cloud-pak-cli/releases/download/v3.3.0/cloudctl-darwin-amd64.tar.gz
wget https://github.com/IBM/cloud-pak-cli/releases/download/v3.3.0/cloudctl-darwin-amd64.tar.gz.sig
```


## Check Certificate/Key Validity

Retrieve the latest public keys (example with wget):
```
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl.pub
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl-chain0.pub
wget https://raw.githubusercontent.com/IBM/cloud-pak-cli/master/cloudctl-chain1.pub
```

#### Verify that the certificate/key is owned by IBM:

```
openssl x509 -inform pub -in cloudctl.pub -noout -text
```

#### Verify authenticity of certificate/key:

```
cat cloudctl-chain0.pub > chain.pub
cat cloudctl-chain1.pub >> chain.pub

openssl ocsp -no_nonce -issuer chain.pub -cert cloudctl.pub -VAfile chain.pub -text -url http://ocsp.digicert.com -respout ocsptest
```

Should see a message that contains:

`Response verify OK`

### Optionally Validate Each Certificate Individually

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

## Install

Extract the archive:
  - `tar -xzf <archive-name>`

There should be a binary executable after extraction

### For MacOS users

MacOS users might be prompted that `cloudctl` is not trusted. There are two ways to get around this:

- Open the cloudctl file in Finder using the Open command, and click the right button to whitelist this application.

or 

- Enable developer-mode for your terminal window, which whitelists everything
  - spctl developer-mode enable-terminal
  - go to system prefs -> security & privacy -> Privacy Tab -> Developer Tools -> Terminal : Enable
  - restart all terminals
