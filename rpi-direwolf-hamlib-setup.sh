#!/bin/sh
#install direwolf(dev) w/HamLib(4.3.1)
#N4XWE 10-12-2021
#Visit http://www.iquadlabs.com


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install pkg-config g++ libfftw3-dev qt5-default libpulse-dev libasound2-dev libv4l-dev libopenjp2-7 libopenjp2-7-dev \
git gcc make cmake libudev-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

#Create a unique directory for the direwolf compile and make it the current directory
mkdir -p ~/src/DIREWOLF && cd ~/src/DIREWOLF

#Download the Hamlib 4.3.1 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/4.3.1/hamlib-4.3.1.tar.gz ||
  { echo 'Unable to download the Hamlib source code file'; exit 1; }
  
#Extract the Hamlib source code files
tar -xvzf hamlib-4.3.1.tar.gz

#Change the directory containing the uncompressed HamLib source code to the current directory
cd ~/src/DIREWOLF/hamlib-4.3.1

#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the Hamlib libraries
make -j3 && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the HamLib library files
sudo ldconfig

#Change the unique directory previously created for the compile to the current directory 
cd ~/src/DIREWOLF

#Download the direwolf source code from Github
git clone https://www.github.com/wb2osz/direwolf  ||
  { echo 'Unable to download the direwolf source code'; exit 1; }
 
#Checkout the stable version of the direwolf source code
git checkout dev

#Change the directory containing the direwolf source code to the current directory
cd ~/src/DIREWOLF/direwolf

#Create an indirect build directory and change it to the current directory
mkdir build && cd build
  
#Configure the Makefile for the direwolf compile to run a self-test
cmake -DUNITTEST=1 ../

#Compile and install direwolf
make -j3 && sudo make install 
make install-conf ||
  { echo 'Unable to install direwolf'; exit 1; }
  
#Install an direwolf icon on the RPi desktop
#echo "[Desktop Entry]
#Name=Dire Wolf
#GenericName=Amateur Radio Software Modem
#Comment=Software Modem
#Exec=/usr/local/bin/direwolf
#Icon=/usr/local/share/pixmaps/direwolf_icon.png
#Terminal=false
#Type=Application
#Categories=Other;HamRadio;" > /home/pi/Desktop/direwolf.desktop ||
#   { echo 'Unable to setup the Direwolf icon'; exit 1;}
