# Overview
Cloudctl is a command line tool to manage Container Application Software for Enterprises (CASEs) 


## Download

1. Download the gzipped tar archive for your OS from the assets in [releases](https://github.com/IBM/cloud-pak-cli/releases)
2. Download the corresponding `.sig` file for verification purposes

macOS example using `curl`:
```
curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-darwin-amd64.tar.gz -o cloudctl-darwin-amd64.tar.gz
curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-darwin-amd64.tar.gz.sig -o cloudctl-darwin-amd64.tar.gz.sig
```

macOS example using `wget`:
```
wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-darwin-amd64.tar.gz
wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-darwin-amd64.tar.gz.sig
```

Linux x86-architecture example using `curl`:
```
curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz -o cloudctl-linux-amd64.tar.gz
curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz.sig -o cloudctl-linux-amd64.tar.gz.sig
```

Linux x86-architecture example using `wget`:
```
wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz
wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz.sig
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

### For macOS Catalina users

Users on macOS Catalina might be prompted that `cloudctl-darwin-amd64` is not a trusted application. There are two ways to get around this:

- Open Finder, control-click  the application `cloudctl-darwin-amd64`, choose **Open** from the menu, and then click **Open** in the dialog that appears. Enter your admin name and password to open the app if promoted.

- Enable developer-mode for your terminal window, which will whitelist everything:
  -  Open Terminal, and enter:
       ```console
       ❯ spctl developer-mode enable-terminal 
      ```
  - Go to System Preferences -> Security & Privacy -> Privacy Tab -> Developer Tools -> Terminal : Enable
  - Restart all terminals

_See https://support.apple.com/en-ca/HT202491 for more information_

## Support

To report an issue or get help please visit https://www.ibm.com/docs/en/cpfs?topic=support-opening-case
