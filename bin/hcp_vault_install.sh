#!/bin/sh

PROCESSOR_ARCHITECTURE=$(uname -m | tr '[:upper:]' '[:lower:]' || echo "unknown")
OPERATING_SYSTEM=$(uname -o | tr '[:upper:]' '[:lower:]' || echo "unknown")

case $PROCESSOR_ARCHITECTURE in
    x86_64)
        ARCH="amd64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unknown processor architecture"
        exit 1
        ;;
esac

case $OPERATING_SYSTEM in
    *linux*)
        OS="linux"
        ;;
    *darwin*)
        OS="darwin"
        ;;
    *)
        echo "Unknown operating system"
        exit 1
        ;;
esac

VLT_VERSION="1.0.0"
VLT_URL="https://releases.hashicorp.com/vlt/${VLT_VERSION}/vlt_${VLT_VERSION}_${OS}_${ARCH}.zip"

curl -L -o - $VLT_URL
unzip vlt.zip
rm vlt.zip
mv vlt $HOME/.local/bin/vlt
vlt --version