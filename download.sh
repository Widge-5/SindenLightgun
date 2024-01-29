#!/bin/bash
if [ $USER == "root" ]; then USERNAME=$SUDO_USER; else USERNAME=$USER; fi
mkdir -p /home/$USERNAME/RetroPie-Setup/ext/Widge-Extras/scriptmodules/supplementary
wget -O /home/$USERNAME/RetroPie-Setup/ext/Widge-Extras/scriptmodules/supplementary/sinden_lightgun.sh https://github.com/Widge-5/SindenLightgun/raw/main/sinden_lightgun.sh
rm -f ./download.sh
