# RHCOS BFB Build

### Pre-requisites
Podman and qemu-user-static are required to build the RHCOS image on a non-aarch64 machine.


### Build the RHCOS image
First use an openshift cluster to check the release image for the RHCOS version you want to build.
```bash
export RHCOS_VERSION="4.17.12"
export TARGET_IMAGE=$(oc adm release info --image-for rhel-coreos "quay.io/openshift-release-dev/ocp-release:"$RHCOS_VERSION"-aarch64")
export BUILDER_IMAGE=$(oc adm release info --image-for driver-toolkit "quay.io/openshift-release-dev/ocp-release:"$RHCOS_VERSION"-aarch64")
export KERNEL_VERSION="5.14.0-427.50.1.el9_4.aarch64"
```

Make sure you export PULL_SECRET, you can obtain it from console.redhat.com.
```bash
export PULL_SECRET=<path to pull secret file>
```

```bash
podman build -f new.Containerfile \
--authfile $PULL_SECRET \
--build-arg D_OS=rhcos4.17 \
--build-arg D_ARCH=aarch64 \
--build-arg D_KERNEL_VER=$KERNEL_VERSION \
--build-arg D_OFED_VERSION=24.10-1.1.4.0 \
--build-arg D_BASE_IMAGE=$BUILDER_IMAGE \
--build-arg D_FINAL_BASE_IMAGE=$TARGET_IMAGE \
```

### Creating disk boot images
```bash
skopeo copy containers-storage:rhcos-bfb:latest oci-archive:rhcos-bfb.ociarchive
git clone https://github.com/coreos/custom-coreos-disk-images.git
```

You can use `fedora:41` as it has the `osbuild-tools` package.
```bash
podman run --rm -it --privileged -v /root:/root fedora:41

# In the container
sudo dnf install -y osbuild osbuild-tools osbuild-ostree podman jq xfsprogs
sudo custom-coreos-disk-images/custom-coreos-disk-images.sh --ociarchive rhcos-bfb.ociarchive --platforms metal
```
