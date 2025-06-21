#!/bin/sh
#install wsjt-x(2.7.0) Hamlib(4.5.4)
#N4XWE 06-20-2025
#Test Compiled on RaspiOS-bookworm dtd 2025-05-12 64-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Check to see if a previous version of Hamlib has been installed
#If the answer is yes, remove the libhamlib4 file 
sudo apt remove libhamlib4 -y

#Add all of the dependencies
sudo apt install -y git cmake automake libtool build-essential \
asciidoc gfortran subversion libwxgtk3.2-dev libusb-1.0-0-dev \
portaudio19-dev libsamplerate0-dev libcfitsio-dev \
zlib1g-dev libgsl-dev libcurl4-gnutls-dev libtheora-dev \
libasound2-dev libao-dev libfftw3-dev libgsm1-dev libtiff-dev \
libjpeg-dev libxft-dev libxinerama-dev libxcursor-dev asciidoctor \
libboost-all-dev libqt5multimedia5 libqt5multimedia5-plugins \
libqt5multimediaquick5 libreadline-dev libqt5multimediawidgets5 \
libqt5serialport5-dev libqt5svg5-dev libqt5widgets5 swig \
libgd-dev libqt5sql5-sqlite libqwt-qt5-dev libsndfile1-dev \
libudev-dev qtmultimedia5-dev texinfo xsltproc qttools5-dev \
qttools5-dev-tools qtbase5-dev-tools ||
	{ echo 'Dependency installation failed'; exit 1; }


#Set the Raspberry Pi CPU optimization Flags for compiling the WSJT-X source code
export CXXFLAGS='-O2 -march=native -mtune=native'
export CFLAGS='-O2 -march=native -mtune=native'

#Create a unique directory for the WSJT-X compile and make it the current directory
mkdir -p ~/src/WSJTX && cd ~/src/WSJTX

#Download the WSJT-X source code from Sourceforge
wget -N https://sourceforge.net/projects/wsjt/files/wsjtx-2.7.0/wsjtx-2.7.0.tgz ||
  { echo 'Unable to download the WSJT-X source code file'; exit 1; }
  
#Extract the WSJT-X source code files
tar -zxvf wsjtx-2.7.0.tgz

#Create a directory for an indirect build of WSJT-X and make it the current directory
mkdir -p ~/src/WSJTX/wsjtx-2.7.0/build && cd ~/src/WSJTX/wsjtx-2.7.0/build

#Configure the Makefile for the WSJT-X compile
cmake ../

#Compile and install the executable and support files for WSJT-X
#The tag -j 3 specifies the number of CPU cores that are used during the compile
#Be aware that more cores equates to higher CPU temperatures
make -j3 && sudo make install ||
  { echo 'Unable to install WSJT-X'; exit 1; }

#Add the CURRENT user to the dialout group
sudo usermod -a -G dialout $USER