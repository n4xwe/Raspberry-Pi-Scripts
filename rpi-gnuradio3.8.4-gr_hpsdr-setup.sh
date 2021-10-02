#!/bin/sh
#install GNU Radio w/Osmocom w/HPSDR
#N4XWE 10-01-2021
#Visit http://www.iquadlabs.com

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Add the compile dependencies
sudo apt install -y git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev baresip \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools python-docutils build-essential liborc-0.4-0 \
liborc-0.4-dev libcairo2-dev python3-gi-cairo python3-pygccxml python3-pyaudio \
libcodec2-dev ||
	{ echo 'Dependency installation failed'; exit 1;}
	
#If you are using an RPI with less than 4GB of memory add and enable a 2GB Swapfile
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile

#Create a unique directory for the GNU Radio compile and make it the current directory
mkdir -p ~/src/GNURadio && cd ~/src/GNURadio

#Clone the latest volk source code from Github
git clone --recurse-submodules -j3 https://github.com/gnuradio/volk.git
  
#Create a directory for an indirect build of the volk libraries and make it the current directory
mkdir -p ~/src/GNURadio/volk/build && cd ~/src/GNURadio/volk/build
	
#Configure the Makefile for the volk libraries compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../

#Compile and install the volk library files
make -j3 && sudo make install ||
  { echo 'Unable to install the volk libraries'; exit 1; }

#Link the volk library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest GNU Radio source code from Github
git clone https://github.com/gnuradio/gnuradio.git

#Change the directory containing the gnuradio source code to the current directory
cd ~/src/GNURadio/gnuradio

#Checkout the maintained version of GNU Radio 3.8 from the cloned GNU Radio repository
git checkout maint-3.8
git submodule update --init --recursive

#Create a directory for an indirect build of GNU Radio and make it the current directory
mkdir -p ~/src/GNURadio/gnuradio/build && cd ~/src/GNURadio/gnuradio/build 

#Configure the Makefile for the GNU Radio compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../

#Compile and install the gnuradio executable and support files
make -j3 && sudo make install ||
  { echo 'Unable to install gnuradio'; exit 1; }

#Link the gnuradio library files
sudo ldconfig

#Change the unique directory previously created for the GNU Radio compile to the current directory 
cd ~/src/GNURadio

#Clone the latest gr-hpsdr source block code from github
git clone https://github.com/Tom-McDermott/gr-hpsdr.git

#Change the directory containing the gr-hpsdr 3.8 source code to the current directory
cd ~/src/GNURadio/gr-hpsdr

#Checkout the gr-hpsdr source code from the cloned gr-hpsdr repository
git checkout gr_3.8

#Create a directory for an indirect build of gr-hpsdr 3.8 and make it the current directory
mkdir -p ~/src/GNURadio/gr-hpsdr/build && cd ~/src/GNURadio/gr-hpsdr/build 

#Configure the Makefile for the gr-hpsdr source block compile
cmake ../ 

#Compile and install the gr-hpsdr 3.8 source block
make -j3 && sudo make install ||
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
