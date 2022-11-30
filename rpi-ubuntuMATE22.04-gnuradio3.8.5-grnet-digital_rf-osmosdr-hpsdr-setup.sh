#!/bin/sh
#install GNU Radio(3.8.5.0) w/gr-net w/digital_rf w/Osmocom w/HPSDR
#N4XWE 7-23-2022
#Test Compiled on Ubuntu 22.04LTS for the Raspberry Pi 64-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Add the compile dependencies
sudo apt install -y git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml python3-doc8 doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools build-essential liborc-0.4-0 liborc-0.4-dev \
libcairo2-dev python3-gi-cairo python3-pygccxml libgmp3-dev zlib1g-dev libpcap-dev \
pybind11-dev python3-pybind11 libosmesa6 tk8.6 dvipng inkscape ipython3 librtlsdr0 \
python3-cairocffi python3-nose python3-tornado texlive-extra-utils librtlsdr-dev \
texlive-latex-extra ttf-staypuft python3-gdal python3-pydot python3-pygraphviz \
libgle3 tix python3-tk-dbg libboost-tools-dev libhdf5-dev python3-pkgconfig \
python3-dev python3-dateutil python3-tz python3-six python3-pandas python3-watchdog ||
	{ echo 'Dependency installation failed'; exit 1;}
	
#If your RPi has less than 4GB of RAM add and enable a 2GB Swapfile
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile

#Create a unique directory for the GNU Radio compile and make it the current directory
mkdir -p ~/src/GNURadio && cd ~/src/GNURadio

#Clone the latest volk source code from Github
git clone --recurse-submodules -j8 https://github.com/gnuradio/volk.git
  
#Create a directory for an indirect build of the volk libraries and make it the current directory
mkdir -p ~/src/GNURadio/volk/build && cd ~/src/GNURadio/volk/build
	
#Configure the Makefile for the volk libraries compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 .. 

#Compile and install the volk library files
make -j 3 && sudo make install ||
  { echo 'Unable to install the volk libraries'; exit 1; }

#Link the volk library files
sudo ldconfig

#Change the unique directory previously created for the GNU Radio compile to the current directory 
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
cmake -DNEON_SIMD_ENABLE=OFF -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../

#Compile and install the gnuradio executable and support files
make -j 3 && sudo make install ||
  { echo 'Unable to install gnuradio'; exit 1; }
  
#Link the GNU Radio library files
sudo ldconfig
 
#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the gr-grnet source block code from github
git clone https://github.com/ghostop14/gr-grnet.git

#Change the directory containing the gr-grnet source code to the current directory
cd ~/src/GNURadio/gr-grnet

#Checkout the maint-3.8 branch of gr-grnet for GNU Radio from the cloned ghostop14 github repository
git checkout maint-3.8
git submodule update --init --recursive

#Create a directory for an indirect build of gr-grnet and make it the current directory
mkdir -p ~/src/GNURadio/gr-grnet/build && cd ~/src/GNURadio/gr-grnet/build 
	
#Configure the Makefile for the gr-grnet source block compile
cmake -DCMAKE_BUILD_TYPE=Release ..

#Compile and install the gr-grnet source block
make -j 3 && sudo make install ||
  { echo 'Unable to install gr-grnet'; exit 1; }
  
#Link the gr-grnet library files
sudo ldconfig

#Change the unique directory previously created for the GNU Radio compile to the current directory 
cd ~/src/GNURadio

#Clone the latest digital_rf source code from Github
git clone --recursive https://github.com/MITHaystack/digital_rf.git
  
#Create a directory for an indirect build of the digital_rf code and make it the current directory
mkdir -p ~/src/GNURadio/digital_rf/build && cd ~/src/GNURadio/digital_rf/build
	
#Configure the Makefile for the digital_rf compile
cmake ..

#Compile the digital_rf files
make -j 3

#Install the compiled digital_rf files
sudo make install ||
  { echo 'Unable to install digital_rf'; exit 1; }

#Link the digital_rf files
sudo ldconfig

#Change the unique directory previously created for the GNU Radio compile to the current directory 
cd ~/src/GNURadio

#Clone the latest gr-osmosdr source block code from osmocom.org
git clone git://git.osmocom.org/gr-osmosdr.git

#Change the directory containing the gr-osmosdr source code to the current directory
cd ~/src/GNURadio/gr-osmosdr

#Checkout the gr3.8 branch of gr-osmosdr for GNU Radio from the cloned osmosdr github repository
git checkout gr3.8
git submodule update --init --recursive

#Create a directory for an indirect build of gr-osmosdr and make it the current directory
mkdir -p ~/src/GNURadio/gr-osmosdr/build && cd ~/src/GNURadio/gr-osmosdr/build 
	
#Configure the Makefile for the gr-osmosdr source block compile
cmake .. 

#Compile and install gr-osmosdr
make && sudo make install ||
  { echo 'Unable to install gr-osmosdr'; exit 1; }
 
#Link the gr-osmosdr library files
sudo ldconfig

#Change the unique directory previously created for the GNU Radio compile to the current directory 
cd ~/src/GNURadio

#Clone the latest gr-hpsdr source code from github
git clone https://github.com/Tom-McDermott/gr-hpsdr.git

#Change the directory containing the gr-hpsdr source code to the current directory
cd ~/src/GNURadio/gr-hpsdr

#Checkout the gr_3.8 branch of gr-hpsdr for GNU Radio from the cloned gr-hpsdr github repository
git checkout gr_3.8
git submodule update --init --recursive

#Create a directory for an indirect build of gr-hpsdr 3.8 and make it the current directory
mkdir -p ~/src/GNURadio/gr-hpsdr/build && cd ~/src/GNURadio/gr-hpsdr/build 
	
#Configure the Makefile for the gr-hpsdr source block compile
cmake .. 

#Compile and install the gr-hpsdr 3.8 source block
make -j 3 && sudo make install ||
  { echo 'Unable to install gr-hpsdr'; exit 1; }
  
#Link the gr-hpsdr library files
sudo ldconfig

#Make the GNU Radio Library and Python Path statements permanent
echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.10/dist-packages" >> ~/.profile
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
Categories=Programming" >> ~/Desktop/gnuradio-companion.desktop ||
   { echo 'Unable to setup a gnuradio companion desktop icon'; exit 1;}
