# RPi-Scripts
BASH Scripts that Install Ham Radio Software on the Raspberry Pi
These BASH scripts install either GNU Radio, WSJT-X, PiHPSDR, Fldigi or qsstv on a Raspberry Pi using the Raspberry Pi (formerly Raspbian) Operating System.  The scripts have been tested on an 8GB RPi 4 running the December 2nd, 2020, full release of the 32-bit version of the Raspberry Pi OS.  They may or may not work successfully on other models of the Raspberry Pi or other versions of the Raspberry Pi Operating System.  

In order for the script to function correctly you must have a reasonable connection to the Internet.  The suggested method of launching the scripts is to create a separate directory named src off of the $HOME directory (/home/pi/src).  Copy the script file to the src directory.  Using the Command Line change the file permissions of the script to allow its execution (chmod +x name-of-the script.sh).  You can achieve the same result by doing a right click on your script and choosing Properties from the pop-up menu, then switch to the Permissions tab, tick the "Allow Executing File as Program" box.  From the command line preface the script name with a dot slash (./name-of-the-script.sh) on the Terminal and press the Enter key.  

The script will update all of the packages on your Operating System to their latest versions.  It will also locate, download and compile all of the requisite source code.  In many instances there are statements in the scripts that place icons on the Desktop and provide essential configuration of the software.  In the case of GNU Radio the script installs two Python configuration statements but the OS must be rebooted to enable them.  

All of the scripts have detailed inline comments that explain the function of every line in the script.  They are offered under GPL v3.0 and can be easily modified by any user.

PiHPSDR, by John Melton, G0ORX, is an absolutely excellent lightweight SDR Console that works with a variety of radios.  It uses the WDSP library for signal processing, has the capability of implementing Puresignal adaptive pre-distortion, has an intuitive interface and is very stable. PiHPSDR interfaces with other programs through the Pulse audio transport system.  Compile time on a Raspberry Pi 4 is approximately 8 minutes.

GNU Radio, originally developed Matt Ettus is a powerful DSP toolkit. It has a graphical interface that allows allows almost any DSP function to be performed on RF derived signals.  Compile time on a Raspberry Pi 4 is TBD Minutes.

WSJT-X by Joe Taylor, K1JT, and currently supported by a group of very talented developers is weak signal software that includes, among other programs, FT8, FT4, JT8 and WSPR. The script also compiles the most recent version of the Hamlib library for integrated rig control,  Compile time on a Raspberry Pi 4 is TBD Minutes.

Fldigi by Dave Freese, W1HKJ, and others is a digital mode console with integrated Hamlib rig control.  This console handles a multitude of digital modes including PSK-31, WeatherFax, Hellschreiber and CW.  Compile time on a Raspberry Pi 4 is approximately 30 minutes.

qsstv is a digital or analog Slow Scan Television program. Compile time on a Raspberry Pi 4 is TBD Minutes.
