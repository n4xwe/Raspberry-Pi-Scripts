#!/bin/sh
#install freedv (1.6.1) w/codec2 w/LPCNet 
#N4XWE 9-28-2021
#Visit http://www.iquadlabs.com

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt -y update && sudo apt -y upgrade


#Download and install the required build dependencies
sudo apt -y install cmake subversion libwxgtk3.0-gtk3-dev portaudio19-dev \
libusb-1.0-0-dev libsamplerate0-dev libasound2-dev libao-dev libgsm1-dev \
libsndfile1-dev libjpeg9-dev libxft-dev libxinerama-dev libxcursor-dev \
libspeex-dev libspeexdsp-dev libreadline-dev libhamlib-dev ||
	{ echo 'Dependency download failed'; exit 1;}

#Create a 2GB swapfile
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile

#Set the compiler optimization flags
export CXXFLAGS='-O2 -march=native -mtune=native'
export CFLAGS='-O2 -march=native -mtune=native'

#Make a unique directory for the FreeDV compile and make it the current directory
mkdir -p ~/src/FreeDV && cd ~/src/FreeDV || 
	{ echo 'Unable to create the FreeDV dir'; exit 1; }
	
#Download the codec2 source code from Github
git clone https://github.com/drowe67/codec2.git ||
  { echo 'Unable to download codec2'; exit 1; }

#Change the directory containing the uncompressed codec2 source code to the current directory
cd codec2

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the makefile
cmake  ../

#Compile and install and link the Codec2 source code
make && sudo make install && sudo ldconfig ||
  { echo 'Unable to compile Codec2'; exit 1; }
  
#Change the unique directory previously created for the compile to the current directory
cd ~/src/FreeDV

#Download the LPCNet source code
git clone https://github.com/drowe67/LPCNet.git

#Change the directory containing the uncompressed LPCNet source code to the current directory
cd LPCNet

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the makefile
cmake -DCODEC2_BUILD_DIR=~/src/FreeDV/codec2/build ../ 

#Compile and install the LPCNet source
make && sudo make install ||
  { echo 'Unable to make and install LPCNet'; exit 1; }

#Change the Codec2 build directory to the current directory
cd ~/src/FreeDV/codec2/build

#Remove any unnecessary files
rm -Rf *

#Configure the cmake file
cmake -DLPCNET_BUILD_DIR=~/src/FreeDV/LPCNet/build ../ 

#Remake Codec2 with LPCNet and install and link the libraries
make && sudo make install && sudo ldconfig ||
  { echo 'Unable to Recompile Codec2 with LPCNet'; exit 1; }
  
#Change the unique directory previously created for the compile to the current directory
cd ~/src/FreeDV

#Download the freedv-gui source code
git clone https://github.com/drowe67/freedv-gui.git

#Change the directory containing the uncompressed LPCNet source code to the current directory
cd freedv-gui
  
#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the cmake file
cmake -DCMAKE_BUILD_TYPE=Debug -DCODEC2_BUILD_DIR=~/src/FreeDV/codec2/build -DLPCNET_BUILD_DIR=~/src/FreeDV/LPCNet/build ../

#Make and install freedv-gui with Codec2 and LPCNet 
make && sudo make install ||
  { echo 'Unable to compile and install freedv-gui'; exit 1; }

#Add odroid to the dialout user group
sudo usermod -a -G dialout pi

#Add a FreeDV icon to the Desktop
echo "[Desktop Entry]
Name=FreeDV
GenericName=Amateur Radio Digital Voice
Comment=FreeDV Digital Voice
Exec=/usr/local/bin/freedv
Icon=/usr/local/share/icons/hicolor/64x64/apps/freedv.png
Terminal=false
Type=Application
Categories=Other" > ~/Desktop/freedv.desktop ||
   { echo 'Unable to setup FreeDV icon'; exit 1;}
