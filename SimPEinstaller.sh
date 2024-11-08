#!/bin/bash

if [[ $1 == "--uninstall" ]]; then
	echo "uninstalling..."
	rm -rf /home/$USER/.local/share/simpe
	rm /home/$USER/.local/share/applications/SimPe.desktop
	exit
fi
missingdependency=0
#check for wine and winetricks dependencies
if ! command -v wine 2>&1 >/dev/null; then
	echo "couldn't find wine, please install it"
	missingdependency=1
fi

if ! command -v winetricks 2>&1 >/dev/null; then
	echo "couldn't find winetricks, please install it"
	missingdependency=1
fi

if ! command -v curl 2>&1 >/dev/null; then
	echo "couldn't find curl, please install it"
	missingdependency=1
fi

if ! command -v wget 2>&1 >/dev/null; then
	echo "couldn't find wget, please install it"
	missingdependency=1
fi

if ! command -v tar 2>&1 >/dev/null; then
	echo "couldn't find tar, please install it"
	missingdependency=1
fi

if [ $missingdependency -eq 1 ]; then
	exit
fi

#create wineprefix and install dotnet40
echo "Installing dependencies in wineprefix"
echo "You will have to accept the TOS and click your way through the installer"
echo "Ignore any terminal output until the installer window closes"
mkdir ~/.local/share/simpe
#silencing as much output as possible because it wont be useful anyways
WINEPREFIX=~/.local/share/simpe WINEDEBUG=-all winetricks dotnet40 2>&1 >/dev/null

#download and unpack simpe
echo "Installing SimPe"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/reblyn/SimPe_Linux_Installer/releases/latest | grep "browser_download_url" | grep -o "https://.*SimPe\.tar\.gz")
#NOTE: for some reason wget and tar don't like the shortcut '~' to the home directory
wget -q $DOWNLOAD_URL -O "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/SimPe.tar.gz"
if [ ! $? -eq 0 ]; then
	echo "Failed to download SimPe release"
	echo "Tried downloading from the following link:"
	echo $DOWNLOAD_URL
	exit
fi
tar -xf "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/SimPe.tar.gz" -C "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/"
rm "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/SimPe.tar.gz"

#creating the start menu entry
#same here, have to replace ~ with the full path
echo "Creating start menu entry"
curl -s "https://raw.githubusercontent.com/Reblyn/SimPE_Linux_Installer/refs/heads/main/SimPe.desktop" | sed "s/~/\/home\/$USER/g" > ~/.local/share/applications/SimPe.desktop

#Download and install Nvidia DDS
#If Jensen Huang is reading this, sorry for probably violating the software license
#But you should really fix your linux drivers
echo "Installing Nvidia DDS Utilities"
mkdir "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/NVIDIA Corporation"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/reblyn/SimPe_Linux_Installer/releases/latest | grep "browser_download_url" | grep -o "https://.*DDS-Utilities\.tar\.gz")
wget -q $DOWNLOAD_URL -O "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/NVIDIA Corporation/DDS-Utilities.tar.gz"
if [ ! $? -eq 0 ]; then
	echo "Failed to download DDS-Utilities"
	echo "Tried downloading from the following link:"
	echo $DOWNLOAD_URL
	exit
fi
tar --warning=no-unknown-keyword -xf "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/NVIDIA Corporation/DDS-Utilities.tar.gz" -C "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/NVIDIA Corporation"
rm "/home/$USER/.local/share/simpe/drive_c/Program Files (x86)/NVIDIA Corporation/DDS-Utilities.tar.gz"
