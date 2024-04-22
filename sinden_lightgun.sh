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
    local depends=(mono-complete v4l-utils libsdl1.2-dev libsdl-image1.2-dev libjpeg-dev xmlstarlet evtest fbi)
    if isPlatform "64bit"; then
        depends+=(libsdl2-dev libsdl2-image-dev)
    fi
    getDepends "${depends[@]}"
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
    cp -v "$md_build/Scripts/*.txt" "$home/Lightgun/utils"
    cp -v "$md_build/Scripts/*.png" "$home/Lightgun/utils"
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

    # # Add in a new Sinden Lighgun entry to RetroPie's gamelist.xml
	local function
	for function in $(compgen -A function _add_rom_); do
		"$function" "retropie" "RetroPie" "Sinden Lightgun.sh" "Sinden Lightgun" "Start, stop, test and calibrate your Sinden Lightguns. Includes Autostart settings." "$home/RetroPie/retropiemenu/icons/sinden.svg"
	done
	

elif [[ "$md_mode" == "remove" ]]; then

    echo "REMOVING"
    
    /home/pi/Lightgun/utils/sindenautostart.sh -u

    rm -r "$home/Lightgun"
    rm "$home/RetroPie/retropiemenu/Sinden Lightgun.sh"
    rm "$home/RetroPie/retropiemenu/icons/sinden.svg"


    # Check RetroPie's gamelist.xml to see if an entry for Sinden Lightgun exists, and remove it if it does --this might not always work
    if xmlstarlet sel -t -v "//game[name='Sinden Lightgun']" "/home/pi/gamelist.xml" > /dev/null 2>&1; then
        xmlstarlet ed --inplace --delete "//game[name='Sinden Lightgun']" "/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml"
    fi
	
fi

# Update this script with the latest version from the (github) repo.
# This is in case new dependencies are needed in future versions.
local searchterm1='rp_module_id="sinden_lightgun"'
local searchterm2='rp_module_desc="Sinden Lightgun Stuff"'
local location="$(cd "$(dirname "$0")" && pwd)/ext"
echo "Searching for location of RetroPie-Setup sinden_lightgun install script..."

if [ ! -d "$location" ]; then
	echo "Unable to find location. RetroPie-Setup sinden_lightgun install script not updated with server version."
else
    found=$(grep -rl --include="*.sh" "$searchterm1" "$location" | xargs grep -l "$searchterm2")
    if [ -n "$found" ]; then
        echo "Updating RetroPie-Setup sinden_lightgun install script with server version."
		cp -v "$md_build/sinden_lightgun.sh" $found
    else
        echo "Unable to find location. RetroPie-Setup sinden_lightgun install script not updated with server version."
    fi
fi

}
