#!/bin/sh
#install QSSTV(9.5.11) w/HamLib(4.5)
#N4XWE 1-25-2024
#Test Compiled on Ubuntu 23.10 64-bit with a Raspberry Pi 5


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install pkg-config g++ libfftw3-dev libpulse-dev libasound2-dev libv4l-dev \
libopenjp2-7 libopenjp2-7-dev doxygen libqwt-qt5-dev libqt5svg5-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

#Create a unique directory for the QSSTV compile and make it the current directory
mkdir -p ~/src/QSSTV && cd ~/src/QSSTV

#Download the Hamlib 4.5 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/4.5/hamlib-4.5.tar.gz ||
  { echo 'Unable to download the Hamlib source code file'; exit 1; }
  
#Extract the Hamlib source code files
tar -xvzf hamlib-4.5.tar.gz

#Change the directory containing the uncompressed HamLib source code to the current directory
cd ~/src/QSSTV/hamlib-4.5

#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the Hamlib libraries
make -j3 && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the HamLib library files
sudo ldconfig

#Change the unique directory previously created for the compile to the current directory 
cd ~/src/QSSTV

#Download the QSSTV source code from Github
git clone  https://github.com/ON4QZ/QSSTV.git ||
  { echo 'Unable to download the QSSTV source code'; exit 1; }
  
#Change the directory containing the uncompressed QSSTV source code to the current directory
cd ~/src/QSSTV/QSSTV/src

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the Makefile for the QSSTV compile
qmake ..

#Compile and install QSSTV
make -j3 && sudo make install ||
  { echo 'Unable to install QSSTV'; exit 1; }
  
#Copy the qsstv icon to a persistent system directory
sudo cp ~/src/QSSTV/QSSTV/src/icons/qsstv.png /usr/local/share/applications

#Install a QSSTV icon on the RPi desktop
echo "[Desktop Entry]
Name=QSSTV
GenericName=Amateur Radio SSTV
Comment=Slow Scan TV
Exec=/usr/local/bin/qsstv
Icon=/usr/local/share/applications/qsstv.png
Terminal=false
Type=Application
Categories=Other;HamRadio;" > ~/Desktop/qsstv.desktop ||
   { echo 'Unable to setup the QSSTV icon'; exit 1;}
