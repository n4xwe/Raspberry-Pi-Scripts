#!/bin/bash
#install Dream(2.2) with FAAD2(2.7) and FAAC(1.28)
#N4XWE 3-23-2021
#Compiled on RaspiOS-buster dtd 2021-01-11 32-bit

set -e

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Install the required dependencies
sudo apt install -y libhamlib2 libqwt6abi1 g++ unzip make qt4-dev-tools libsysfs-dev automake \
libtool libtool-bin libqtwebkit-dev libqt5webkit5-dev libpulse-dev libhamlib-dev qt4-qmake \
libfftw3-dev libqwt-dev libsndfile1-dev zlib1g-dev libgl1-mesa-dev libqt4-opengl-dev libpcap-dev \
libspeexdsp-dev

#Create a unique directory for the DREAM compile and make it the current directory
mkdir -p ~/src/DREAM && cd ~/src/DREAM

#Download the faad2 library source code from Sourceforge
wget https://sourceforge.net/projects/faac/files/faad2-src/faad2-2.7/faad2-2.7.tar.gz  ||
  { echo 'Unable to download the faad2 source code'; exit 1; }

#Extract the faad2 source code files
tar zxvf faad2-2.7.tar.gz

#Change the directory containing the faad2 source code to the current directory
cd faad2-2.7

#Configure the faad2 Makefile
./configure --enable-shared --without-xmms --with-drm --without-mpeg4ip

#Compile the faad2 libraries with three CPU cores
make -j3

#Copy the faad header files to the /usr/include directory
sudo cp include/faad.h include/neaacdec.h /usr/include

#Copy the faad library files to the /usr/local/lib directory
sudo cp libfaad/.libs/libfaad.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2.0.0

#Create a Soft Link between the file names of the compiled libfaad2_drm files and the file names the OS expects
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so

#Link the faad2 library files library files
sudo ldconfig

#Move the current directory up one level
cd ..

#Download the faac library source code from Sourceforge
wget https://sourceforge.net/projects/faac/files/faac-src/faac-1.28/faac-1.28.tar.gz

#Extract the faac source code files
tar zxvf faac-1.28.tar.gz

#Change the directory containing the faac source code to the current directory
cd faac-1.28

#Configure the faac Makefile
./configure --with-pic --enable-shared --without-mp4v2 --enable-drm

#Compile the faac libraries with three CPU cores
make -j3

#Copy the faac header files to the /usr/include directory
sudo cp include/faaccfg.h  include/faac.h /usr/include

#Copy the faac library files to the /usr/local/lib directory
sudo cp libfaac/.libs/libfaac.so.0.0.0 /usr/local/lib/libfaac_drm.so.0.0.0

#Create soft links between the file names of the compiled libfaac_drm files and the file names the Dream configuration expects
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so.0
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so

#Link the faac library files library files
sudo ldconfig

#Move the current directory up one level to ~/src/Dream
cd ..

#Download the Dream source code from Sourceforge
wget http://downloads.sourceforge.net/drm/dream_2.2.orig.tar.gz

#Extract the Dream source code files
tar zxvf dream_2.2.orig.tar.gz

#Change the directory containing the Dream source code to the current directory
cd dream-2.2

#In the dream.pro file insert in every instance "/usr" in place of "$$USD"
sed -i -- 's#$$PWD#/usr#g' dream.pro

#Configure the Dream Makefile
qmake-qt4

#Compile the Dream source code with three CPU cores
make -j3

#Copy the Dream executable file to the /usr/local/lib directory
sudo cp dream /usr/local/bin/dream

#Copy the Dream icon to the /usr/share/icons directory
sudo cp src/GUI-QT/res/MainIcon.svg /usr/share/icons/dream.svg

#Link the recently copied Dream files
sudo ldconfig

#Move the current directory up one level
cd ..

#Add an icon to launch Dream to the Desktop
echo "[Desktop Entry]
Name=Dream
GenericName=DRM Receiver
Comment=Software Digital Radio Mondiale Receiver
Exec=/usr/local/bin/dream
Icon=/usr/share/icons/dream.svg
Terminal=false
Type=Application
Categories=Other" > ~/Desktop/dream.desktop ||
   { echo 'Unable to setup Dream icon'; exit 1;}

#Cleanup the files thaat were used to compille Dream but are no longer required
rm dream_2.2.orig.tar.gz
rm faac-1.28.tar.gz
rm faad2-2.7.tar.gz
rm -rf ./dream
rm -rf ./faac-1.28
rm -rf ./faad2-2.7
