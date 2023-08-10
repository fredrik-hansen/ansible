Simple how-to for Morpheus, notes to myself...
# Docker way
docker pull nvcr.io/nvidia/morpheus/morpheus:23.07-runtime
docker run --rm -ti --runtime=nvidia --gpus=all --net=host -v /var/run/docker.sock:/var/run/docker.sock nvcr.io/nvidia/morpheus/morpheus:23.11-runtime bash

Enter container, run:
./external/utilities/docker/install_docker.sh


#May the source be with me:


MORPHEUS_ROOT=$(pwd)/morpheus
git clone https://github.com/nv-morpheus/Morpheus.git $MORPHEUS_ROOT
cd $MORPHEUS_ROOT


