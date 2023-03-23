#!/bin/sh
#install tweaktime 
#N4XWE 3-22-2023
#Test Compiled on RaspiOS-bullseye dtd 2023-02-22 64-bit



#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Download and install the dependencies
sudo apt -y install build-essential ||
	{ echo 'Dependency installation failed'; exit 1; }

#Create a unique directory for the tweaktime compile and make it the current directory
mkdir -p ~/src/TWEAKTIME && cd ~/src/TWEAKTIME

#Download the most recent version of the tweaktime source code
wget -N https://kk5jy.net/tweaktime/Software/tweaktime-20200413a.tar.xz ||
  { echo 'Unable to download the tweaktime source code file'; exit 1; }
  
#Extract the tweaktime source code files
tar -xvf tweaktime-20200413a.tar.xz

#Change the directory containing the tweaktime source code to the current directory
cd ~/src/TWEAKTIME/tweaktime

#Compile and install tweaktime
make -j3 && sudo make install ||
  { echo 'Unable to install tweaktime'; exit 1; }
  

  




