#!/bin/sh
#install GNU Radio w/Osmocom w/hpsdr
#N4XWE 12-8-2020
#Visit http://www.iquadlabs.com

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Add the compile dependencies
sudo apt -y install git cmake build-essential synaptic libusb-1.0-0-dev libltdl-dev libreadline-dev libsndfile1-dev \
g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev libstdc++-8-dev-armhf-cross \
libusb-1.0-0 doxygen-latex libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-1.2-dev libpopt-dev \
tcl8.5-dev python3-gi-cairo python3-cairo-dev python-cairo libspeex-dev libasound2-dev alsa-utils libgcrypt20-dev \
python3-pygccxml libpopt-dev libfltk1.3-dev libpng++-dev libghc-gi-cairo-dev libghc-cairo-dev python-cairo-dev liborc-0.4-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml \
python3-click python3-click-plugins libportaudio-dev libpulse-dev libportaudiocpp0 libcairo2-dev python3-dev \
libgirepository1.0-dev libcppunit-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

#Add and enable a 2GB Swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#Create a unique directory for the GNU Radio compile and make it the current directory
mkdir -p ~/src/GNURadio && cd ~/src/GNURadio

#Clone the latest volk source code from Github
git clone --recurse-submodules -j8 https://github.com/gnuradio/volk.git
  
#Create a directory for an indirect build of the volk libraries and make it the current directory
mkdir -p ~/src/GNURadio/volk/build && cd ~/src/GNURadio/volk/build
	
#Configure the Makefile for the volk libraries compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 .. 

#Compile and install the volk library files
make && sudo make install ||
  { echo 'Unable to install the volk libraries'; exit 1; }

#Link the volk library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest GNU Radio source code from Github
git clone https://github.com/gnuradio/gnuradio.git

#Make the directory containing the gnuradio source code the current directory
cd ~/src/GNURadio/gnuradio

#Checkout the maintained version of GNU Radio 3.8 from the cloned GNU Radio repository
git checkout maint-3.8
git submodule update --init --recursive

#Create a directory for an indirect build of GNU Radio and make it the current directory
mkdir -p ~/src/GNURadio/gnuradio/build && cd ~/src/GNURadio/gnuradio/build 

#Configure the Makefile for the GNU Radio compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ..

#Compile and install the gnuradio executable and support files
make && sudo make install ||
  { echo 'Unable to install gnuradio'; exit 1; }
  
#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest gr-osmosdr source block code from osmocom.org
git clone git://git.osmocom.org/gr-osmosdr

#Make the directory containing the gr-osmosdr source code the current directory
cd ~/src/GNURadio/gr-osmosdr

#Create a directory for an indirect build of gr-osmosdr and make it the current directory
mkdir -p ~/src/GNURadio/gr-osmosdr/build && cd ~/src/GNURadio/gr-osmosdr/build 
	
#Configure the Makefile for the gr-osmosdr source block compile
cmake .. 

#Compile and install gr-osmosdr
make && sudo make install ||
  { echo 'Unable to install gr-osmosdr'; exit 1; }
 
#Link the gr-osmosdr library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest gr-hpsdr source block code from github
git clone https://github.com/Tom-McDermott/gr-hpsdr.git

#Make the directory containing the gr-hpsdr 3.8 source code the current directory
cd ~/src/GNURadio/gr-hpsdr

#Checkout the gr-hpsdr source code from the cloned gr-hpsdr repository
git checkout gr_3.8

#Create a directory for an indirect build of gr-hpsdr 3.8 and make it the current directory
mkdir -p ~/src/GNURadio/gr-hpsdr/build && cd ~/src/GNURadio/gr-hpsdr/build 
	
#Configure the Makefile for the gr-hpsdr source block compile
cmake .. 

#Compile and install the gr-hpsdr 3.8 source block
make && sudo make install ||
  { echo 'Unable to install gr-hpsdr'; exit 1; }
  
#Link the gr-hpsdr library files
sudo ldconfig

#Make the GNU Radio Library and Python Path statements permanent
echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.8/dist-packages" >> ~/.profile
echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.profile

#Install a Gnuradio Companion icon on the desktop
echo "[Desktop Entry]
Type=Application
Version=1.0
Encoding=UTF-8
Name=GNU Radio Companion
GenericName=Digital Signal Processing Software
Exec=/usr/local/bin/gnuradio-companion
Icon=/usr/local/share/icons/hicolor/32x32/apps/gnuradio-grc.png
Terminal=false
StartupNotify=false
Categories=Programming" >> /home/pi/Desktop/gnuradio-companion.desktop ||
   { echo 'Unable to setup a gnuradio companion desktop icon'; exit 1;}
