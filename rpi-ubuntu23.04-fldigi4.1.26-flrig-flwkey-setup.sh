#!/bin/sh
#install fldigi(4.1.26) w/Hamlib(4.6-Git) flrig(2.0.01) flwkey(1.2.3) 
#N4XWE 4-20-2023
#Test compiled on Ubuntu 23.04 64-bit


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libltdl-dev libreadline-dev libsndfile1-dev \
g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libusb-1.0-0 libgd-dev libsamplerate0 libsamplerate0-dev libsigc++-2.0-dev libpopt-dev \
tcl-dev libspeex-dev libasound2-dev libgd-dev alsa-utils libgcrypt20-dev libpopt-dev libfltk1.3-dev libpng++-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml \
python3-click python3-click-plugins libportaudio2 libpulse-dev libportaudiocpp0 libblas-dev liblapack-dev \
autopoint debhelper dh-autoreconf dh-strip-nondeterminism dwz fltk1.3-doc fluid libarchive-cpio-perl libdebhelper-perl \
libfile-stripnondeterminism-perl libfltk-cairo1.3 libfltk-forms1.3 libfltk-gl1.3 libfltk-images1.3 libfltk1.3 \
libfltk1.3-dev libflxmlrpc-dev libflxmlrpc1 libmbedcrypto7 libmbedtls-dev libmbedtls14 \
libmbedx509-1 libsub-override-perl po-debconf libudev-dev ||
	{ echo 'Dependency installation failed'; exit 1;}

#If your RPi has less than 8GB of memory remove the pound signs in the following statements in order to add and enable a 2GB Swapfile
#sudo fallocate -l 2G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile
	
#Check to see if a previous version of Hamlib has been installed
#If the answer is yes, remove the libhamlib2 file 
sudo apt remove libhamlib2 -y
  
#Create a unique directory for the FLDIGI compile and make it the current directory
mkdir -p ~/src/FLDIGI && cd ~/src/FLDIGI

#Download the Hamlib 4.6-git source code from Sourceforge
git clone https://git.code.sf.net/p/hamlib/code hamlib ||
  { echo 'Unable to download the HamLib source code file'; exit 1; }
  
#Change the directory containing the uncompressed Hamlib source code the current directory
cd ~/src/FLDIGI/hamlib

#Reconfigure the git files with the bootstrap script
./bootstrap

#Configure the Makefile for the Hamlib compile
./configure --without-cxx-binding 

#Compile and install the Hamlib libraries
make -j 3 && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the Hamlib library files
sudo ldconfig

#Install the portaudio19-dev dependency
sudo apt -y install portaudio19-dev ||
	{ echo 'Install portaudio19 failed'; exit 1;}

#Change the unique directory previously created for the compile to the current directory 
cd ~/src/FLDIGI

#Download the fldigi-4.1.26 source code from Sourceforge
wget -N https://sourceforge.net/projects/fldigi/files/fldigi/fldigi-4.1.26.tar.gz ||
  { echo 'Unable to download the fldigi source code file'; exit 1; }

#Extract the fldigi source code files
tar -xvzf fldigi-4.1.26.tar.gz ||
  { echo 'Unable to extract fldigi'; exit 1; }
  
#Change the directory containing the uncompressed fldigi source code to the current directory
cd ~/src/FLDIGI/fldigi-4.1.26

#Configure the Makefile for the fldigi compile
./configure

#Compile and install fldigi
make -j3 && sudo make install ||
  { echo 'Unable to install fldigi'; exit 1; }

#Change the unique directory previously created for the compile to the current directory 
cd ~/src/FLDIGI

#Download the flrig 2.0.01 source code from Sourceforge
wget -N https://sourceforge.net/projects/fldigi/files/flrig/flrig-2.0.01.tar.gz ||
  { echo 'Unable to download the flrig source code file'; exit 1; }

#Extract the flrig source code files
tar -xvzf flrig-2.0.01.tar.gz ||
  { echo 'Unable to extract flrig'; exit 1; }
  
#Change the directory containing the uncompressed flrig source code to the current directory
cd ~/src/FLDIGI/flrig-2.0.01

#Configure the Makefile for the flrig compile
./configure

#Compile and install flrig
make && sudo make install ||
  { echo 'Unable to install flrig'; exit 1; }
  
#Change the unique directory previously created for the compile to the current directory 
cd ~/src/FLDIGI

#Download the flwkey-1.2.3 source code from Sourceforge
wget -N https://sourceforge.net/projects/fldigi/files/flwkey/flwkey-1.2.3.tar.gz ||
  { echo 'Unable to download the flwkey source code file'; exit 1; }

#Extract the flwkey source code files
tar -xvzf flwkey-1.2.3.tar.gz ||
  { echo 'Unable to extract flwkey'; exit 1; }
  
#Change the directory containing the uncompressed flwkey source code to the current directory
cd ~/src/FLDIGI/flwkey-1.2.3

#Configure the Makefile for the flwkey compile
./configure

#Compile and install flwkey
make -j3 && sudo make install ||
  { echo 'Unable to install flwkey'; exit 1; }

#Change the unique directory previously created for the compile to the current directory 
cd ~/src/FLDIGI 

#Download the setGPIO file
wget -N http://www.elazary.com/images/mediaFiles/ham/hampi/setGPIO ||
  { echo 'Unable to retrieve setGPIO'; exit 1; }

#If the setGPIO file exists start it at boot time
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
Categories=Network;HamRadio;" > ~/Desktop/fldigi.desktop ||
   { echo 'Unable to setup the fldigi desktop icon'; exit 1;}

