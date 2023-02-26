#!/bin/sh
#install NanoVNA-Saver(0.5.5pre)
#N4XWE 2-19-2023
#Test Compiled on RaspiOS-bullseye dtd 2022-09-22 64-bit

sudo apt update && sudo apt -y upgrade

sudo apt -y install git python3-pyqt5 python3-scipy 

mkdir -p ~/src/NANOVNA && cd ~/src/NANOVNA

git clone https://github.com/NanoVNA-Saver/nanovna-saver
 
cd nanovna-saver

sudo chmod +r ~/src/NANOVNA/nanovna-saver/nanovna-saver.py

python3 nanovna-saver.py

sudo cp /home/dan/src/NANOVNA/nanovna-saver/NanoVNASaver_48x48.png /usr/share/pixmaps/NanoVNASaver_48x48.png

echo "[Desktop Entry]
Name=Nano-Saver
GenericName=VNA Software Client
Comment=Runs NanoVNA Saver
Exec=$HOME/src/NANOVNA/nanovna-saver/nanovna-saver.py
Icon=/usr/share/pixmaps/NanoVNASaver_48x48.png
Terminal=false
Type=Application
Categories=Other;HamRadio;" > ~/Desktop/NanoVNA-Saver.desktop
