<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Overview](#overview)
  - [Download](#download)
  - [Check Certificate/Key Validity and Archives](#check-certificatekey-validity-and-archives)
  - [Install](#install)
    - [For macOS Catalina users](#for-macos-catalina-users)
  - [Support](#support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

**DEPRECATION NOTICE:**  The ` cloudctl case` command is deprecated in favor of [ibm-pak plugin](https://github.com/IBM/ibm-pak-plugin). Support for them will be removed in a future release. More information is available at https://ibm.biz/cloudctl-case-deprecate.

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


## Check Certificate/Key Validity and Archives

* [cloudctl versions less than v3.23.1](doc/verify.md)

* [cloudctl versions greater than or equal to v3.23.1](doc/verify-v2.md)

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
