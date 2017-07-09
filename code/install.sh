#!/bin/bash
#####################
# Author: Alexandre Amory
# Date: September/2016, December/2016, July/2017 
# Laboratorio de Sistemas Autonomos - FACIN - PUCRS University
# Description:
#   This script installs Player/Stage
# How to run this script
#   > cd <main_path>/code/
#   > chmod 755 ./install.sh
#   > ./install.sh
# How to test Player/Stage: 
#   > cd /usr/local/share/stage/worlds
#   > player simple.cfg

# Any subsequent(*) commands which fail will cause the shell script to exit immediately. v for verbose
set -ev

#defensive script
#http://www.davidpashley.com/articles/writing-robust-shell-scripts/#id2382181

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

OS=$(lsb_release -si)
VER=$(lsb_release -sr)
OSNAME=$(lsb_release -sc)
NUM_CORES=`cat /proc/cpuinfo | grep processor | wc -l`

echo -e "${GREEN}NOTE:${NC} ${OS} - ${VER} (${OSNAME}.\n"
echo -e "${GREEN}NOTE:${NC} This computer has ${NUM_CORES} cores ...\n"

##################################################
# install commom packages
##################################################
sudo apt-get install -y build-essential
sudo apt-get install -y autoconf
sudo apt-get install -y cmake
sudo apt-get install -y cmake-curses-gui
sudo apt-get install -y git
sudo apt-get install -y pkg-config

##################################################
# install Player/Stage depedencies
##################################################
sudo apt-get install -y libfltk1.1-dev 
sudo apt-get install -y freeglut3-dev 
sudo apt-get install -y libpng12-dev 
sudo apt-get install -y libltdl-dev 
#libltdl7 
case "${VER}" in 
    14.04)
        sudo apt-get install -y libdb5.1-stl
        ;;
    16.04)
        sudo apt-get install -y libdb5.3-stl
        ;;
esac
sudo apt-get install -y libgnomecanvasmm-2.6-dev
sudo apt-get install -y python-gnome2
#sudo apt-get install -y libboost-all-dev  # overkill, the actually required libraries are boostthread, boostsignal, boostsystem
sudo apt-get install -y libboost-signals-dev libboost-system-dev libboost-thread-dev
# old OpenCV for older Player drivers
sudo apt-get install -y libopencv-dev libopencv-core-dev libcv-dev libcvaux-dev libhighgui-dev
# alsa - sound player
sudo apt-get install -y libasound2-dev
# alsa alsa-tools  alsa-utils
# for pmap
sudo apt-get install -y libgsl0-dev libxmu-dev
# for python bindings for Player clients - 
# It is not recommended to use python due to limitations in the bindings. 
# Things that work on a C/C++ client might not work on a Python client.
sudo apt-get install -y python-dev swig
# PostGIS for a Player driver
sudo apt-get install -y libpq-dev libpqxx-dev
# if you want to compile the html document, enable this line
#sudo apt-get install -y doxygen

##################################################
# Downloading source code 
##################################################
echo -e "${GREEN}Downloading Player source code from GitHub... ${NC}\n"
git clone https://github.com/playerproject/player.git

echo -e "${GREEN}Downloading Stage source code from GitHub... ${NC}\n"
git clone https://github.com/lsa-pucrs/Stage.git

##################################################
# set environment variables
##################################################
# these are the required environment variables for Ubuntu. Other distributions might have slightly different path names
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib/:${LD_LIBRARY_PATH}
# Opencv lib path
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}
# Player lib path
export LD_LIBRARY_PATH=/usr/local/lib64/:${LD_LIBRARY_PATH}
# setup pkgconfig and cmake. Try the following commands to find where these files are located and add all of them 
# run 'sudo find / -name "*.pc" -type f' to find all the pc files for pkg-config
# run 'sudo find / -name "*.cmake" -type f' to find all the cmake files for cmake
case "${VER}" in 
    14.04)
        export CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}:/usr/share/cmake-2.8/Modules/:/usr/share/cmake-2.8/Modules/Platform/:/usr/share/cmake-2.8/Modules/Compiler/:/usr/local/share/cmake/Modules:/usr/local/lib64/cmake/Stage/:/usr/lib/fltk/
        ;;
    16.04)
        export CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}:/usr/share/cmake-3.5/Modules/:/usr/share/cmake-3.5/Modules/Platform/:/usr/share/cmake-3.5/Modules/Compiler/:/usr/local/share/cmake/Modules:/usr/local/lib/cmake/Stage/:/usr/lib/fltk/
        ;;
esac
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig/:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:${PKG_CONFIG_PATH}

##################################################
# Compile and install Player/Stage 
##################################################
cd player
mkdir -p build
cd build
echo -e "${GREEN}Configuring Player ... ${NC}\n"
# Player has tones of parameters that can be setup individually. try 'ccmake ..' in the build dir to select them individually
# Fow now, we are using the default intallation, disabling Python bidings
cmake -DCMAKE_BUILD_TYPE=Release -DDEBUG_LEVEL=NONE -BUILD_PYTHONC_BINDINGS:BOOL=OFF ..
echo -e "${GREEN}Compiling Player ... ${NC}\n"
make -j ${NUM_CORES} 
sudo make install
echo -e "${GREEN}Player installed !!!! ${NC}\n"

cd ../../Stage
mkdir -p build
cd build
echo -e "${GREEN}Configuring Stage  ... ${NC}\n"
# Stage also have some parameters that can be selected individually. Fow now, we are using the default intallation
cmake -DCMAKE_BUILD_TYPE=Release ..
echo -e "${GREEN}Compiling Stage ... ${NC}\n"
make -j ${NUM_CORES}
sudo make install
echo -e "${GREEN}Stage installed !!!! ${NC}\n"
