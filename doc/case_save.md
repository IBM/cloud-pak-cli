# cloudctl case save example

`cloudctl case save` saves the contents of your CASE locally. This includes the CASE itself and any dependent CASEs and Helm charts. Container images referenced by your CASE will be compiled in a comma separated values (CSV) file that can be used to mirror your images into a local image repository.

## Example

```
$ cloudctl case save --case "$CASE_LOC" --outputdir /tmp/case
Downloading and extracting the CASE ...
- Success
Retrieving CASE version ...
- Success
Validating the CASE ...
- Success
Creating inventory ...
- Success
Finding inventory items
- Success
Resolving inventory items ...
Parsing inventory items
- Success
```

### Sample Output Structure

This example shows the output of a `cloudctl case save` command for a CASE with the following hierarchy:

```bash
├── case1
│   ├── chart1
│   ├── case2
│   │   ├──chart2
```

The output includes the two Helm charts in tgz format in the charts directory, two CASE tgzs for the two CASEs in the root directory, and csv files containing information about which helm charts and container images are associated with each of the CASEs.

```bash
├── charts
│   ├── chart1-1.0.0.tgz
│   ├── chart2-2.0.0.tgz
├── case1-1.0.0-charts.csv
├── case1-1.0.0-images.csv
├── case1-1.0.0.tgz
├── case2-2.0.0-charts.csv
├── case2-2.0.0-images.csv
└── case2-2.0.0.tgz
```

No container images were downloaded using `cloudctl case case`, only the metadata about them. If you are installing the product on a system that has a connection to the internet, the images do not need to be downloaded prior to using `cloudctl case launch` to install. If you need to install the product in a private network environment, then the contents of the image csv files is important.

### Images CSV

The images CSV file contains a list of all the images that are referenced by a CASE.  

The CASE references either a specific image manifest (architecture, os and variant), or a manifest list, when the CASE supports multiple architectures.

If a Manifest List is specified, it must always represent the entire set of manifests.  It cannot include a subset:
1.  Most repositories require the images to be present before creating the manifest list.  
2.  If images are removed from the manifest list the digest will change.

Name format: 
`<case>-<version>-images.csv`

Fields:
- `hostport`:  The host and optional port of the remote registry where the image resides, in the form of `host[:port]`  (required).
- `name`:  The fully qualified name of the image in the registry (required).
- `tag`: The tag of the manifest. A tag is used for documentation purposes, since the digest is the authoritative identifier for the manifest. (optional).
- `digest`:  The OCI formatted digest of the manifest. (required).
- `mtype`: If `LIST`, the image is a manifest list, `IMAGE` if an image manifest (required).
- `os`: The applicable os of the image (e.g. `amd64`) (required if MLIST=0).
- `arch`:  The applicable architecture of the image (e.g. `linux`). (required if MLIST=0).
- `variant`: The variant of the image (e.g. `v7`) (optional).
- `insecure`: If 1, the image is fetched using `http`, if 0 or not supplied, the image is fetched using `https` (optional).
- `digestsource`: If `REGISTRY`, the digest is current version in the source registry.  If `CASE`, the digest is the version from the CASE (required).

Example nginx-1.17.5-images.csv:
```
hostport,name,tag,digest,mtype,os,arch,variant,insecure,digestsource
registry-1.docker.io,library/nginx,1.17.5,sha256:922c815aa4df050d4df476e92daed4231f466acc8ee90e0e774951b0fd7195a4,LIST,,,,0,CASE
registry-1.docker.io,library/nginx,,sha256:f56b43e9913cef097f246d65119df4eda1d61670f7f2ab720831a01f66f6ff9c,IMAGE,linux,amd64,,0,CASE
registry-1.docker.io,library/nginx,,sha256:585c1ec805ab799d7a8e5082d94aace5c3f1455b75f103ca5ca2b45fdbee75fc,IMAGE,linux,arm,v7,0,CASE
registry-1.docker.io,library/nginx,,sha256:2b947b067421d91891ad5d9d8c5a5882d5352013f4bbcc35604028f975bec8aa,IMAGE,linux,arm64,v8,0,CASE
registry-1.docker.io,library/nginx,,sha256:69f9646f3bb5e2d432e6de6c9be00097c808aed6e8509f6589b886082536affe,IMAGE,linux,386,,0,CASE
registry-1.docker.io,library/nginx,,sha256:6949c49968f8e9155dca74e5ee6d8644d23168f2af248fd9b7045091d13f5d36,IMAGE,linux,ppc64le,,0,CASE
registry-1.docker.io,library/nginx,,sha256:e5d2d2271923ddc74e1d4d81f7e1266eb1e501cc11f6b277ffb89952347e7abc,IMAGE,linux,s390x,,0,CASE
```

#### Using the Images CSV

The image CSV is meant to be parsed, filtered, and used to mirror or download only the images that you need. Some examples:

- Compile a list of all of the images and use `oc image mirror` to pull them locally
- Build a list of only the amd64 images and use `skopeo copy` to mirror them locally
- Build the image path for each image and then update the hostport property to point to an internal repository

To this end, there is a [sample CSV parsing script](samples/parse_csv.sh) found in the samples folder. This script parses one or more image CSV files and uses either `oc image mirror` or `skopeo copy` to mirror the images from the starting repository to an internal repository while keeping their integrity.

### Exit codes

Phase one of this project returns only two possible return codes: 0 for success and 1 for failure. We expect to support additional exit codes in the future and will outline them here when they are available.