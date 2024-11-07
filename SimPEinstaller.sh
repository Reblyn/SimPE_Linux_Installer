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

if ! command -v tar 2>&1 >/dev/null; then
	echo "couldn't find tar, please install it"
	exit
fi

#create wineprefix and install dotnet40
echo "Installing dependencies in wineprefix"
echo "You might see some warnings pop up about a 64 bit prefix"
echo "Just press ok until it is done"
mkdir ~/.local/share/simpe
WINEPREFIX=~/.local/share/simpe winetricks dotnet40

#download and unpack simpe
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/reblyn/SimPe_Linux_Installer/releases/latest | grep "browser_download_url" | grep -o "https://.*\.tar\.gz")
curl -o "~/.local/share/simpe/drive_c/Program Files (x86)/SimPe.tar.gz" $DOWNLOAD_URL
if [ ! $? -eq 0 ]; then
	echo "Failed to download SimPe release"
	echo "Tried downloading from the following link:"
	echo $DOWNLOAD_URL
	exit
fi
tar -xf "~/.local/share/simpe/drive_c/Program Files (x86)/SimPe.tar.gz"

#creating the start menu entry
curl "https://raw.githubusercontent.com/Reblyn/SimPE_Linux_Installer/refs/heads/main/SimPe.desktop" > ~/.local/share/applications/SimPe.desktop
