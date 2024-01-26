#!/usr/bin/env bash

#
# This file is NOT part of The RetroPie Project
#

rp_module_id="sinden_lightgun"
rp_module_desc="Sinden Lightgun Stuff"
rp_module_help="Installs the Sinden Lightgun software for your 32/64 Raspberry Pi, along with Widge's Sinden Lightgun management utility.\n\nBe aware that reinstalling/updating will likely overwrite your LightgunMono config files.\n\nThis package and the Lightgun Management utility were created by Widge in January 2024.\nYouTube: www.youtube.com/@widge\nGitHub:  www.github.com/Widge-5\n\nSinden Lightgun and its logos are registered trademarks owned by Sinden Technology Ltd."
rp_module_repo="git https://github.com/Widge-5/SindenLightgun.git main"
rp_module_section="exp"
rp_module_flags="rpi4 rpi5 rpi"

function depends_sinden_lightgun() {
    getDepends mono-complete v4l-utils libsdl1.2-dev libsdl-image1.2-dev libjpeg-dev xmlstarlet evtest
}

function sources_sinden_lightgun() {
    gitPullOrClone
}


function install_sinden_lightgun() {
    md_ret_files=(
        './Scripts/uninstall.txt'
    )
}


function configure_sinden_lightgun() {

if [[ "$md_mode" == "install" ]]; then

 echo "INSTALLING"

    mkUserDir "$home/Lightgun"
    mkUserDir "$home/Lightgun/utils"

    cp -v "$md_build/Scripts/sindenautostart.sh" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/recoiltcs.txt" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/help.txt" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/Sinden Lightgun.sh" "$home/RetroPie/retropiemenu/"
    cp -v "$md_build/Scripts/sinden.svg" "$home/RetroPie/retropiemenu/icons/"
    cp -v $md_build/Borders/* /opt/retropie/emulators/retroarch/overlays/

    if isPlatform "64bit"; then
	echo "Installing 64bit Drivers"
        cp -rv $md_build/64bit/* $home/Lightgun/
    else
	echo "Installing 32bit Drivers"
        cp -rv $md_build/32bit/* $home/Lightgun/
    fi

    ## Clean up ownerships and permissions ##
    chown -R $user:$user "$home/Lightgun"
    chown -R $user:$user "$home/RetroPie/retropiemenu"
    chmod +x "$home/RetroPie/retropiemenu/Sinden Lightgun.sh"
    chmod +x "$home/Lightgun/utils/sindenautostart.sh"



     # Check RetroPie's gamelist.xml to see if an entry for Sinden Lightgun already exists, and remove it if it does
    if xmlstarlet sel -t -v "//game[name='Sinden Lightgun']" "/home/pi/gamelist.xml" > /dev/null 2>&1; then
        xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
    fi

    # Add in a new Sinden Lighgun entry to RetroPie's gamelist.xml
    xmlstarlet ed --inplace --subnode "/gameList" --type elem -n "game" \
      --subnode "//gameList/game[last()]" --type elem -n "path" -v "./Sinden Lightgun.sh" \
      --subnode "//gameList/game[last()]" --type elem -n "name" -v "Sinden Lightgun" \
      --subnode "//gameList/game[last()]" --type elem -n "desc" -v "Start, stop, test and calibrate your Sinden Lightguns. Includes Autostart settings." \
      --subnode "//gameList/game[last()]" --type elem -n "image" -v "./icons/sinden.svg" \
      "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"

elif [[ "$md_mode" == "remove" ]]; then

    echo "REMOVING"
    
    /home/pi/Lightgun/utils/sindenautostart.sh -u

    rm -r "$home/Lightgun"
    rm "$home/RetroPie/retropiemenu/Sinden Lightgun.sh"
    rm "$home/RetroPie/retropiemenu/icons/sinden.svg"


    # Check RetroPie's gamelist.xml to see if an entry for Sinden Lightgun exists, and remove it if it does
    if xmlstarlet sel -t -v "//game[name='Sinden Lightgun']" "/home/pi/gamelist.xml" > /dev/null 2>&1; then
        xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
    fi
	
fi
  
}
