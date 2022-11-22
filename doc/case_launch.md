**DEPRECATION NOTICE:**  The `cloudctl case` command is deprecated in favor of [ibm-pak plugin](https://github.com/IBM/ibm-pak-plugin). Support for them will be removed in a future release. More information is available at https://ibm.biz/cloudctl-case-deprecate.
# cloudctl case launch example

`cloudctl case launch` executes an action defined in a CASE. As part of this process, it validates the prerequisites for the action and the integrity of the CASE prior to executing the script. A CASE can contain zero or more launch scripts.

## Example

The following example shows a hypothetical CASE with launcher script in the `clusterSetup` inventory item. This launcher has a number of custom parameters that are passed to it via the `--args` parameter.

The first part of the command retrieves the CASE and validates the integrity of the CASE:

```
$ cloudctl case launch --case $CASELOC --namespace $NAMESPACE --inventory clusterSetup --action setup --args "--imageRegistry $IMAGE_REG --imageRegistryUser $USER --imageRegistryPass $TOKEN" 
Welcome to the CASE launcher
Attempting to retrieve and extract the CASE from the specified location
[✓] CASE has been retrieved and extracted
Attempting to validate the CASE
OK
```

The second part of the command finds the specified launch script and checks if the prerequisites have been met on the Kubernetes cluster that you are logged into:

```
Attempting to locate the launch inventory item, script, and action in the specified CASE
[✓] Found the specified launch inventory item, action, and script for the CASE
Attempting to check the cluster and machine for required prerequisites for launching the item
Checking for required prereqs...
/case/prereqs/k8sDistros/kubernetes: true
/case/prereqs/k8sResources/workerIntelLinux: true
/case/prereqs/k8sDistros/ibmCloud: false
/case/prereqs/k8sDistros/ibmCloudPrivate: false
/case/prereqs/k8sDistros/openshift: true
Required prereqs result: OK
Checking user permissions...
rbac.authorization.k8s.io.clusterroles/*: true
apiextensions.k8s.io.customresourcedefinitions/v1beta1: true
/case/prereqs/k8sDistros/openshift: true
/prereqs/k8sDistros/openshift: true
security.openshift.io.securitycontextconstraints/: true
User permissions result: OK
[✓] Cluster and Client Prerequisites have been met for the CASE
```

Finally, the specified script is executed:

```
Running the CASE clusterSetup launch script with the following action context: setup
[✓] CASE launch script completed successfully
OK
```

### Debugging errors

There are three reasons why a launcher script may fail:

1. The CASE has been modified and the signature validation fails

   Each CASE contains a signature to verify the integrity of the contents of the CASE, similar to an md5 hash. If this check fails then that means something in the CASE has changed from its original state and it may not be the product you are expecting. If you are the one who has modified the CASE and are confident in the contents, then the signature verification can be skipped by setting the `-t|--tolerance` flag to 1 or greater.

1. The prerequisite check has failed

   The launcher script is associated with an inventory item and an action within the CASE. The action in the CASE defines a set of cluster prerequisites needed for the script to run successfully. These prerequisites are compared to the cluster that you are logged into. The CASE README should include the set of prerequisites so that if this part of the command fails, it is easier to understand what may be missing.

   More information on how prerequisites are specified in a CASE can be found in the CASE specification for [actions.yaml](https://github.ibm.com/CloudPakOpenContent/case-spec/blob/master/220-actions.md) and [prereqs.yaml](https://github.ibm.com/CloudPakOpenContent/case-spec/blob/master/120-prereqs.md).

1. The script has failed

   The laucher script has failed to complete successfully. Review the output from the script to determine what failed and review the product documentation for ways to fix.

### Exit codes

Phase one of this project returns only two possible return codes: 0 for success and 1 for failure. We expect to support additional exit codes in the future, including propogating exit codes from the launch scripts.

### CASE validation

Each CASE contains two files for validating the authenticity of the CASE: digests.yaml and signature.yaml. The digests.yaml contains a shasum for the CASE as well as any other resources that are referenced by the CASE. These resources include files, container images, Helm charts, and other CASEs. The signature.yaml contains an encrypted shasum of the contents of the files in the CASE. Each file represents a point-in-time reference for the specific CASE.

The digests.yaml is verified during `cloudctl case save` and the signature.yaml is verified during `cloudctl case launch`.

More information on digests.yaml and signature.yaml can be found in the [CASE specification documentation](https://github.com/ibm/case).

#### A note on floating tags

As stated previously, digests.yaml and signature.yaml represent a point-in-time reference for a CASE. If a CASE references a mutable image tag, such as `latest` and the image is updated between when the CASE is published and `cloudctl case launch` is run, then signature validation will fail. If you seeing signature validation fail for this reason, and you are confident in the pedigree of the CASE, then this validation can be bypassed by setting the `-t | --tolerance` flag to 1.