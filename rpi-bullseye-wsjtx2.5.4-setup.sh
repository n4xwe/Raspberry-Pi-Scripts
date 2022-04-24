#!/bin/sh
#install wsjt-x(2.5.4) Hamlib(4.4)
#N4XWE 4-10-2022
#Test Compiled on RaspiOS-bullseye dtd 2021-10-30 32-bit dtd 2022-01-28 32-bit and dtd 2022-04-04 32-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Check to see if a previous version of Hamlib has been installed
#If the answer is yes, remove the libhamlib2 file 
sudo apt remove libhamlib2 -y

#Add all of the dependencies
sudo apt install -y git cmake automake libtool build-essential \
asciidoc gfortran subversion libwxgtk3.0-gtk3-dev libusb-1.0-0-dev \
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

#Create a unique directory for the WSJT-X compile and make it the current directory
mkdir -p ~/src/WSJTX && cd ~/src/WSJTX

#Download the Hamlib 4.4 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/4.4/hamlib-4.4.tar.gz ||
  { echo 'Unable to download the HamLib source code file'; exit 1; }
  
#Extract the Hamlib source code files
tar -xvzf hamlib-4.4.tar.gz

#Make the directory containing the uncompressed Hamlib source code the current directory
cd ~/src/WSJTX/hamlib-4.4

#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the Hamlib libraries
make -j3 && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the Hamlib library files
sudo ldconfig

#Set the Raspberry Pi CPU optimization Flags for compiling the WSJT-X source code
export CXXFLAGS='-O2 -march=native -mtune=native'
export CFLAGS='-O2 -march=native -mtune=native'

#Make the unique directory previously created for the compile the current directory 
cd ~/src/WSJTX

#Download the WSJT-X source code from Sourceforge
wget -N https://sourceforge.net/projects/wsjt/files/wsjtx-2.5.4/wsjtx-2.5.4.tgz ||
  { echo 'Unable to download the WSJT-X source code file'; exit 1; }
  
#Extract the WSJT-X source code files
tar -zxvf wsjtx-2.5.4.tgz

#Create a directory for an indirect build of WSJT-X and make it the current directory
mkdir -p ~/src/WSJTX/wsjtx-2.5.4/build && cd ~/src/WSJTX/wsjtx-2.5.4/build

#Configure the Makefile for the WSJT-X compile
cmake ../

#Compile and install the executable and support files for WSJT-X
#The tag -j 3 specifies the number of CPU cores that are used during the compile
#Be aware that more cores equates to higher CPU temperatures
make -j3 && sudo make install ||
  { echo 'Unable to install WSJT-X'; exit 1; }

#Add the current user to the dialout group
sudo usermod -a -G dialout $USER