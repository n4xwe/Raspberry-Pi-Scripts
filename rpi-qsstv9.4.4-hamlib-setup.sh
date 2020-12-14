#!/bin/sh
#install QSSTV(9.4.4) w/HamLib(4.0~rc3)
#N4XWE 12-11-2020
#Visit http://www.iquadlabs.com


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install g++ libfftw3-dev qt5-default libpulse-dev libasound2-dev libv4l-dev libopenjp2-7 libopenjp2-7-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

#Add and enable a 2GB Swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile	

#Create a unique directory for the QSSTV compile and make it the current directory
mkdir -p ~/src/QSSTV && cd ~/src/QSSTV

#Download the Hamlib 4.0~rc3 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/4.0~rc3/hamlib-4.0~rc3.tar.gz ||
  { echo 'Unable to download the Hamlib source code file'; exit 1; }
  
#Extract the Hamlib source code files
tar -xvzf hamlib-4.0~rc3.tar.gz

#Make the directory containing the uncompressed HamLib source code the current directory
cd ~/src/QSSTV/hamlib-4.0~rc3

#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the Hamlib libraries
make && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the HamLib library files
sudo ldconfig

#Make the unique directory previously created for the compile the current directory 
cd ~/src/QSSTV

#Download the QQSTV source code from Telenet
wget -N http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.4.4.tar.gz  ||
  { echo 'Unable to download the QSSTV source code'; exit 1; }
  
#Extract the QSSTV source code
tar -xvzf qsstv_9.4.4.tar.gz

#Make the directory containing the uncompressed QSSTV source code the current directory
cd ~/src/QSSTV/qsstv_9.4.4

#Configure the Makefile for the QSSTV compile
qmake

#Compile and install QSSTV
make && sudo make install ||
  { echo 'Unable to install QSSTV'; exit 1; }
  
#Copy the qsstv icon to a persistent system directory
sudo cp ~/src/QSSTV/qsstv_9.4.4/qsstv/icons/qsstv.png /usr/local/share/applications

#Install an Fldigi icon on the RPi desktop
echo "[Desktop Entry]
Name=QSSTV
GenericName=Amateur Radio SSTV
Comment=Slow Scan TV
Exec=/usr/local/bin/qsstv
Icon=/usr/local/share/applications/qsstv.png
Terminal=false
Type=Application
Categories=Other;HamRadio;" > /home/pi/Desktop/qsstv.desktop ||
   { echo 'Unable to setup the fldigi icon'; exit 1;}
