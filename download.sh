#!/bin/bash


function manual_dir() {
	local bTest=false
	while ! $bTest; do
		echo " "
		echo "Please type the location of your RetroPie-Setup installation. (Ctrl+C to quit)"
		read -p "$home_dir/" rpsetup_path
		rpsetup_path="$home_dir/$(echo "$rpsetup_path" | sed 's/\/$//')"
		if [ -e "$rpsetup_path/retropie_setup.sh" ]; then
			echo "Confirmed.  Location is valid."
			bTest=true
		else
			echo "Specified directory does not appear to contain retropie_setup.sh. Try again."
		fi
	done
}



if [ $USER == "root" ]; then USERNAME=$SUDO_USER; else USERNAME=$USER; fi

# Get the user's home directory
home_dir="/home/$USERNAME"


# First check the standard location of RetroPie-Setup for retropie_setup.sh and if not
# found, search for the file within the user's home folder and extract the directory path	
rpsetup_path="$home_dir/RetroPie-Setup"
if ! [ -e "$rpsetup_path/retropie_setup.sh" ]; then
	rpsetup_path=$(find "$home_dir" -name "retropie_setup.sh" 2>/dev/null)
fi

# Check if directory_path is empty
if [ -z "$rpsetup_path" ]; then
    echo "Directory containing retropie_setup.sh not found in $home_dir."
	manual_dir
else
	echo " "
	test=false
	echo "Directory containing retropie_setup.sh: $rpsetup_path"
	while ! $test; do
		read -p 'Is this correct? (Y|N) ' yn
		case $yn in
			[Yy]* )
				echo "Location accepted..."
				test=true
				;;
			[Nn]* )
				echo "Location Rejected..."
				test=true
				manual_dir
				;;
			[Qq]* )
				echo "Quitting..."
				test=true
				;;
			* )
				echo "Please press Y or N.  Ctrl+C to quit."
				;;
		esac
	done	
	
fi


echo " "
echo "Downloading and adding package to RetroPie-Setup..."
mkdir -p "$rpsetup_path/ext/Widge-Extras/scriptmodules/supplementary"
wget -O "$rpsetup_path/ext/Widge-Extras/scriptmodules/supplementary/sinden_lightgun.sh" https://github.com/Widge-5/SindenLightgun/raw/main/sinden_lightgun.sh
chown -R $USERNAME:$USERNAME "$rpsetup_path/ext/Widge-Extras/"
echo " "
echo "Installation complete. Now run RetroPie-Setup to install the utility."

echo " "
read -p 'Do you wish to delete this downloader?' yn
case $yn in
	[Yy]* )
		rm -- "$0"
		echo "Downloader deleted."
		;;
	* )
		echo "Downloader not deleted."
		;;
esac
echo " "
