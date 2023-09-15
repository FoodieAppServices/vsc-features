#!/bin/zsh

GCLOUD_VER="${VERSION:-"lts"}"
INSTALL_FIRESTORE_EMULATOR="${INSTALLFIRESTOREEMULATOR:-""}"

ARCH=$(uname -m)
ZSHRC=${HOME}/.zshrc

function add_path {
    echo "path+=$1" >>${ZSHRC}
}

if [ "$ARCH" = "aarch64" ]; then
    GCLOUD_ARCH="arm"
else
    GCLOUD_ARCH="x86_64"
fi

GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VER}-linux-${GCLOUD_ARCH}.tar.gz"

echo "Will instal GCloud from $GCLOUD_URL"

cd /opt
sudo chmod a+rw /opt
curl ${GCLOUD_URL} -o gcloud.tgz
tar xvf gcloud.tgz &>/dev/null
echo "Installing firestore"
chmod -R a+rw google-cloud-sdk

if [[ "${INSTALL_ANT}" = "true" ]] && ! ant -version >/dev/null; then
    sdk_install ant ${ANT_VERSION}
    yes | google-cloud-sdk/bin/gcloud components install beta cloud-firestore-emulator
fi
echo "path+=/opt/google-cloud-sdk/bin" >>${ZSHRC}
echo "Removing archive"
rm gcloud.tgz
