#!/bin/sh
#install FLDIGI(4.1.17) w/Hamlib(4.0~rc4)
#N4XWE 12-14-2020
#Visit http://www.iquadlabs.com


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libltdl-dev libreadline-dev libsndfile1-dev \
g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libusb-1.0-0 libgd-dev libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-1.2-dev libpopt-dev \
tcl8.5-dev libspeex-dev libasound2-dev libgd-dev alsa-utils libgcrypt20-dev libpopt-dev libfltk1.3-dev libpng++-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml \
python3-click python3-click-plugins libportaudio-dev libpulse-dev libportaudiocpp0 ||
	{ echo 'Dependency installation failed'; exit 1;}

#Create a unique directory for the FLDIGI compile and make it the current directory
mkdir -p ~/src/FLDIGI && cd ~/src/FLDIGI

#Download the Hamlib 4.0~rc4 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/4.0~rc4/hamlib-4.0~rc4.tar.gz ||
  { echo 'Unable to download the HamLib source code file'; exit 1; }
  
#Extract the Hamlib source code files
tar -xvzf hamlib-4.0~rc4.tar.gz

#Make the directory containing the uncompressed HamLib source code the current directory
cd ~/src/FLDIGI/hamlib-4.0~rc4

#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the HamLib libraries
make && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the Hamlib library files
sudo ldconfig

#Install the portaudio19-dev dependency
sudo apt -y install portaudio19-dev ||
	{ echo 'Install portaudio19 failed'; exit 1;}

#Make the unique directory previously created for the compile the current directory 
cd ~/src/FLDIGI

#Download the fldigi-4.1.17 source code from Sourceforge
wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-4.1.17.tar.gz ||
  { echo 'Unable to download the fldigi source code file'; exit 1; }

#Extract the fldigi source code files
tar -xvzf fldigi-4.1.17.tar.gz ||
  { echo 'Unable to extract fldigi'; exit 1; }
  
#Make the directory containing the uncompressed fldigi source code the current directory
cd ~/src/FLDIGI/fldigi-4.1.17

#Configure the Makefile for the fldigi compile
./configure

#Compile and install fldigi
make && sudo make install ||
  { echo 'Unable to install fldigi'; exit 1; }

#Make the unique directory previously created for the compile the current directory 
cd ~/src/FLDIGI 

#Download the setGPIO file
wget -N http://www.elazary.com/images/mediaFiles/ham/hampi/setGPIO ||
  { echo 'Unable to retrieve setGPIO'; exit 1; }

#If the setGPIO file exists start it boot time
if ! grep -q setGPIO ~/.bashrc  ; then 
  echo "sudo sh /home/pi/FLDIGI/setGPIO" >> ~/.bashrc
fi

#If snd-mixer-oss kernel module exists start it at boot time
if ! grep -q snd-mixer-oss /etc/modules  ; then 
  sudo sh -c "echo snd-mixer-oss >> /etc/modules"
fi

#If the snd-pcm-oss kernel module exists start it at boot time
if ! grep -q snd-pcm-oss /etc/modules  ; then 
  sudo sh -c "echo snd-pcm-oss >> /etc/modules"
fi

#Install an Fldigi icon on the RPi desktop
echo "[Desktop Entry]
Name=Fldigi
GenericName=Amateur Radio Digital Modem
Comment=Amateur Radio Sound Card Communications
Exec=/usr/local/bin/fldigi
Icon=/usr/local/share/pixmaps/fldigi.xpm
Terminal=false
Type=Application
Categories=Network;HamRadio;" > /home/pi/Desktop/fldigi.desktop ||
   { echo 'Unable to setup the fldigi desktop icon'; exit 1;}
