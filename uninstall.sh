#!/bin/bash

set -e

BASE_DIR=/opt/intel

if [[ -d $BASE_DIR/sgx-ra-sample ]]; then
	sudo rm -rf $BASE_DIR/sgx-ra-sample
	sudo rm $BASE_DIR/Intel_SGX_Attestation_RootCA.pem
fi

[[ -d $BASE_DIR/libsgx-enclave-common/ ]] && sudo $BASE_DIR/libsgx-enclave-common/cleanup.sh
if [[ -d $BASE_DIR/sgxdriver/ ]]; then
       	sudo $BASE_DIR/sgxdriver/uninstall.sh
	rm $BASE_DIR/sgx_linux_x64_driver_2.5.0_2605efa.bin
fi
sudo dpkg -P libsgx-urts libsgx-enclave-common
[[ -d $BASE_DIR/sgxsdk/ ]] && sudo $BASE_DIR/sgxsdk/uninstall.sh
[[ -d $BASE_DIR/linux-sgx/ ]] && sudo rm -rf $BASE_DIR/linux-sgx/

if [[ -d $BASE_DIR/sgx-ra-sample/ ]]; then
	sudo rm -rf $BASE_DIR/sgx-ra-sample/
	sudo rm $BASE_DIR/Intel_SGX_Attestation_RootCA.pem
fi

if [ -z "$(ls -A $BASE_DIR)" ]; then
	sudo rmdir $BASE_DIR
fi
