### Configs for ansible

#### How to use:
`sudo apt install ansible git`

`sudo ansible-pull -o -U https://github.com/fredrik-hansen/ansible.git`

#### For convenience it will add a scheduled job to check for updates at intervals, so you only need to run the above once.

To install dockerfiles, below can be used

`export NM=lvim && cd $NM && docker build -t $NM . && docker tag $NM:latest digitalcompanion/$NM:v1.0 && docker push digitalcompanion/$NM:v1.0 && cd ..`



 9. Conda Installation

This section describes the installation and configuration of CUDA when using the Conda installer. The Conda packages are available at https://anaconda.org/nvidia.
9.1. Conda Overview

The Conda installation installs the CUDA Toolkit. The installation steps are listed below.
9.2. Installing CUDA Using Conda

To perform a basic install of all CUDA Toolkit components using Conda, run the following command:

conda install cuda -c nvidia

9.3. Uninstalling CUDA Using Conda

To uninstall the CUDA Toolkit using Conda, run the following command:

conda remove cuda

9.4. Installing Previous CUDA Releases

All Conda packages released under a specific CUDA version are labeled with that release version. To install a previous version, include that label in the install command such as:

conda install cuda -c nvidia/label/cuda-11.3.0

9.5. Upgrading from cudatoolkit Package

If you had previously installed CUDA using the cudatoolkit package and want to maintain a similar install footprint, you can limit your installation to the following packages:

    cuda-libraries-dev

    cuda-nvcc

    cuda-nvtx

    cuda-cupti



LATEST_VERSION=$(curl -s "https://api.github.com/repos/ddo/fast/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')

curl -L https://github.com/ddo/fast/releases/download/v${LATEST_VERSION}/fast_linux_$(dpkg --print-architecture) -o fast

