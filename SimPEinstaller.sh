#!/bin/bash

#check for wine and winetricks dependencies
if ! command -v wine 2>&1 >/dev/null; then
	echo "couldn't find wine, please install it"
	exit
fi

if ! command -v winetricks 2>&1 >/dev/null; then
	echo "couldn't find winetricks, please install it"
	exit
fi

if ! command -v curl 2>&1 >/dev/null; then
	echo "couldn't find curl, please install it"
	exit
fi

if ! command -v wget 2>&1 >/dev/null; then
	echo "couldn't find wget, please install it"
	exit
fi

if ! command -v tar 2>&1 >/dev/null; then
	echo "couldn't find tar, please install it"
	exit
fi

#create wineprefix and install dotnet40
echo "Installing dependencies in wineprefix"
echo "You will have to accept the TOS and click your way through the installer"
mkdir ~/.local/share/simpe
#silencing as much output as possible because it wont be useful anyways
WINEPREFIX=~/.local/share/simpe WINEDEBUG=-all winetricks dotnet40 2>&1 >/dev/null

#download and unpack simpe
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/reblyn/SimPe_Linux_Installer/releases/latest | grep "browser_download_url" | grep -o "https://.*\.tar\.gz")
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
curl -s "https://raw.githubusercontent.com/Reblyn/SimPE_Linux_Installer/refs/heads/main/SimPe.desktop" | sed "s/~/\/home\/$USER/g" > ~/.local/share/applications/SimPe.desktop
