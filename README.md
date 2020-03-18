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

#### Verify that the certificate is owned by IBM:

`openssl x509 -inform pem -in cloudctl_cert.pub -noout -text`

#### Verify that the certificate is still active:

`openssl ocsp -no_nonce -issuer cloudctl_cert_chain0.pub -cert cloudctl_cert.pub -VAfile cloudctl_cert_chain0.pub -text -url http://ocsp.digicert.com -respout ocsptest`

Should see a message that contains 

`Response verify OK`

#### Verify that the intermediate certificate is still active:

`openssl ocsp -no_nonce -issuer cloudctl_cert_chain1.pub -cert cloudctl_cert_chain0.pub -VAfile cloudctl_cert_chain1.pub -text -url http://ocsp.digicert.com -respout ocsptest`

Should see a message that contains 

`Response verify OK`


## Verify Binary

Download the following file from the assests in [releases](https://github.com/IBM/cloud-pak-cli/releases):
- cloudctl_key.pub

#### Verify the binary:

`openssl dgst -sha256 -verify cloudctl_key.pub -signature <cloudctl_signature_file> <binary_file>`

e.g.

`openssl dgst -sha256 -verify cloudctl_key.pub -signature cloudctl-darwin-amd64.sig cloudctl-darwin-amd64`

Should see a message that contains 

`Verified OK`

## cloudctl case command reference

Learn about the `cloudctl case` commands that you can run to manage you CASEs.

### cloudctl case save

Save the contents of your CASE locally.

- Example
```
cloudctl case save --case <CASE_PATH_OR_URL> --outputdir <OUTPUT_DIR>

OPTIONS:
   --case value, -c value       The local path or URL containing the CASE file to parse
   --outputdir value, -o value  The output directory to which the CASE resources will be placed. The output directory will be created if it does not exist
   --tolerance value, -t value  tolerance levels for validating the CASE 
                                 0 - maximum validation 
                                 1 - reduced validation 
                                 (default: 0)
```

### cloudctl case launch

Executes the specified CASE launcher script

- Example
```
cloudctl case launch --case <CASE-PATH> [additional parameters]

OPTIONS:
   --action value, -a value     The name of the action item launched
   --args value, -r value       Other arguments. Refer to documentation for specifics.
   --case value, -c value       The root directory to the extracted CASE
   --instance value, -i value   The name of the instance of the target application (release)
   --inventory value, -e value  The name of the inventory item launched
   --namespace value, -n value  The name of the target namespace
   --tolerance value, -t value  tolerance levels for validating the CASE 
                                 0 - maximum validation 
                                 1 - reduced validation 
                                 (default: 0)
```