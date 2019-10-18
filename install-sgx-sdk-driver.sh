#!/bin/bash

set -e

sudo apt-get install -y build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake

: "${BASE_DIR:=/opt/intel}"
: "${VERSION:=2.6}"

[[ -d $BASE_DIR ]] || sudo mkdir -p $BASE_DIR && sudo chown `whoami` $BASE_DIR

cd $BASE_DIR
git clone https://github.com/intel/linux-sgx.git
cd linux-sgx
git checkout sgx_${VERSION}
./download_prebuilt.sh
make -j 6
make sdk_install_pkg -j 6
make deb_pkg -j 6
$BASE_DIR/linux-sgx/linux/installer/bin/sgx_linux_x64_sdk_${VERSION}.100.51363.bin --prefix=$BASE_DIR/

sudo dpkg -i $BASE_DIR/linux-sgx/linux/installer/deb/libsgx-urts_${VERSION}.100.51363-bionic1_amd64.deb $BASE_DIR/linux-sgx/linux/installer/deb/libsgx-enclave-common_${VERSION}.100.51363-bionic1_amd64.deb

cd $BASE_DIR
wget https://download.01.org/intel-sgx/linux-${VERSION}/ubuntu18.04-server/sgx_linux_x64_driver_2.5.0_2605efa.bin
chmod +x sgx_linux_x64_driver_2.5.0_2605efa.bin
sudo ./sgx_linux_x64_driver_2.5.0_2605efa.bin
