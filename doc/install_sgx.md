## Prerequisites
```
sudo apt update
sudo apt install -y build-essential ocaml automake autoconf libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev libprotobuf-c-dev git cmake wget python3
```

## Download and Install the Intel SGX SDK

```
wget https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu24.04-server/sgx_linux_x64_sdk_2.25.100.3.bin
chmod +x sgx_linux_x64_sdk_2.25.100.3.bin
./sgx_linux_x64_sdk_2.25.100.3.bin

```

## Set Up Environment Variables

```
echo "source /path/to/sgxsdk/environment" >> ~/.bashrc
source ~/.bashrc

```

## Build and Run Sample Applications
```
cd /path/to/sgxsdk/SampleCode/LocalAttestation
make SGX_MODE=SIM
cd bin/
./app

/* Sample output
* succeed to load enclaves.                                                        
* succeed to establish secure channel.
* Succeed to exchange secure message...
* Succeed to close Session...
*/
```