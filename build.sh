#!/bin/bash

RHEL_VER=9.4
TARGET_REPOFILE=workspace/rhel.repo

ARCH=${ARCH:-"arm64-dpu"}
DOCA_VERSION="2.9.1"
DISTRO="rhel"
DISTRO_DOCA_VERSION="9.2"
BSP_VERSION="4.9.1-13442"
MLNX_OFED_VERSION="24.10-1.1.4.0"
IMAGE_TYPE=${IMAGE_TYPE:-"prod"}
BASE_URL=${BASE_URL:-"https://linux.mellanox.com/public/repo"}

repos=(
  "baseos"
  "appstream"
  "codeready-builder"
)

for repo in ${repos[@]}; do
  echo "[rhel-$RHEL_VER-$repo]" >> workspace/rhel.repo
  echo "name=Red Hat Enterprise Linux $RHEL_VER - $repo" >> workspace/rhel.repo
  echo "baseurl=https://rhsm-pulp.corp.redhat.com/content/eus/rhel9/$RHEL_VER/\$basearch/$repo/os/" >> workspace/rhel.repo
  echo "enabled=1" >> workspace/rhel.repo
  echo "gpgcheck=1" >> workspace/rhel.repo
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> workspace/rhel.repo
  echo -e "\n" >> workspace/rhel.repo
done

cat << EOF > workspace/doca.repo
[doca]
name=Nvidia DOCA repository
baseurl=$BASE_URL/doca/$DOCA_VERSION/${DISTRO}${DISTRO_DOCA_VERSION}/arm64-dpu/
gpgcheck=0
enabled=1
EOF

