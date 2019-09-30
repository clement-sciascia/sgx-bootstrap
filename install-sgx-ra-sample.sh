#!/bin/bash

set -e

BASE_DIR=/opt/intel

sudo apt-get install -y libcurl4-openssl-dev

cd $BASE_DIR
if [[ ! -d $BASE_DIR/sgx-ra-sample/ ]]; then
	git clone https://github.com/intel/sgx-ra-sample.git
fi
cd sgx-ra-sample
git checkout 86305123d416053e95e66cbaf4b5476e33920186
./bootstrap
./configure
make -j 6

cd $BASE_DIR
[[ -e Intel_SGX_Attestation_RootCA.pem ]] || wget https://certificates.trustedservices.intel.com/Intel_SGX_Attestation_RootCA.pem
sed -i -e "s|IAS_REPORT_SIGNING_CA_FILE=|IAS_REPORT_SIGNING_CA_FILE=$BASE_DIR/Intel_SGX_Attestation_RootCA.pem|g" $BASE_DIR/sgx-ra-sample/settings

echo ""
echo "---------------------------------------------------------------------"
echo "Edit $BASE_DIR/sgx-ra-sample/settings and fill out the following fields (from your subscription information at https://api.portal.trustedservices.intel.com/developer) :"
echo "SPID"
echo "IAS_PRIMARY_SUBSCRIPTION_KEY"
echo "IAS_SECONDARY_SUBSCRIPTION_KEY"
echo "---------------------------------------------------------------------"
