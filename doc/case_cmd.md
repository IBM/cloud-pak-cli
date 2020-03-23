## cloudctl case

Learn about the `cloudctl case` commands that you can run to manage your CASEs.

### cloudctl case save

Save the contents of your CASE locally.

#### Syntax

```
cloudctl case save --case <CASE_PATH_OR_URL> --outputdir <OUTPUT_DIR>

OPTIONS:
   --case value, -c value       The local path or URL containing the CASE file to parse
   --outputdir value, -o value  The output directory to which the CASE resources will be placed. The output directory will be created if it does not exist
   --tolerance value, -t value  The tolerance level for validating the CASE 
                                 0 - maximum validation 
                                 1 - reduced validation 
                                 (default: 0)
```

#### Examples

1. This example shows how to download the specified CASE from github, extract and parse it, and retrieve the components that make up the CASE.
```
$ cloudctl case save --case https://github.com/IBM/cloud-pak/raw/master/repo/case/sample-case-1.0.0.tgz --outputdir /tmp/cache
```

2. This example shows the same as example one, except the CASE is available locally
```
$ cloudctl case save --case /tmp/repo/case/sample-case-1.0.0.tgz --outputdir /tmp/cache
```

### cloudctl case launch

Executes the specified CASE launcher script

#### Syntax
```
cloudctl case launch --case <CASE-PATH> [additional parameters]

OPTIONS:
   --action value, -a value     The name of the action item launched
   --args value, -r value       Other arguments. Refer to documentation for specifics.
   --case value, -c value       The root directory to the extracted CASE
   --instance value, -i value   The name of the instance of the target application (release)
   --inventory value, -e value  The name of the inventory item launched
   --namespace value, -n value  The name of the target namespace
   --tolerance value, -t value  The tolerance level for validating the CASE 
                                 0 - maximum validation 
                                 1 - reduced validation 
                                 (default: 0)
```

#### Examples

1. This example executes a cluster setup CASE launcher script for the CASE found in /tmp/cache. The script exists in the clusterSetup inventory item and is associated with the setup action. 

```
$ cloudctl case launch --case /tmp/cache --inventory clusterSetup --action setup --args "--serviceAccount sample-sa1"
```

2. This example executes the default CASE launcher script for the CASE found in /tmp/cache. One of the additional arguments points to the folder where the CASE was saved to using `cloudctl case save`.

```
$ cloudctl case launch --case /tmp/cache --args "--localCache /tmp/cache"
```