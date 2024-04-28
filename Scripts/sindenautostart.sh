#!/bin/bash

######################################################################
##
##   Autostart Options for Sinden Lightgun
##   v3.05    April 2024
##   -- By Widge
##
##   For use with Sinden Software v1.08 config files
##   and RetroPie on Raspberry Pi 4 and 5 (32/64 bit)
##
######################################################################



###########################
############  GLOBAL ######
###########################

if [ $USER == "root" ]; then USERNAME=$SUDO_USER; else USERNAME=$USER; fi

backtitle="Autostart Options and Config Editor for Sinden Lightgun - v3.05 -- By Widge"
utilscfg="/home/$USERNAME/Lightgun/utils/widgeutils.cfg"
collectiondir="/opt/retropie/configs/all/emulationstation/collections"


function builder() { if ! grep -Fq "$1" "$3" ; then echo "$1=\"$2\"" >> $3 ; fi ; }


function cfgmaker() {
  if [ ! -f "$utilscfg" ]; then
    echo > $utilscfg
  fi
  if  ! grep -Fq "[ CONFIG LOCATIONS ]" "$utilscfg" ; then
    echo >> $utilscfg
    echo "[ CONFIG LOCATIONS ]" >> $utilscfg
    echo >> $utilscfg
  fi
  builder "<P1normal>" "/home/$USERNAME/Lightgun/Normal/LightgunMono1.exe.config" "$utilscfg"
  builder "<P2normal>" "/home/$USERNAME/Lightgun/Normal/LightgunMono2.exe.config" "$utilscfg"
  builder "<P3normal>" "/home/$USERNAME/Lightgun/Normal/LightgunMono3.exe.config" "$utilscfg"
  builder "<P4normal>" "/home/$USERNAME/Lightgun/Normal/LightgunMono4.exe.config" "$utilscfg"
  builder "<P1recoil>" "/home/$USERNAME/Lightgun/RecMono/LightgunMono1.exe.config" "$utilscfg"
  builder "<P2recoil>" "/home/$USERNAME/Lightgun/RecMono/LightgunMono2.exe.config" "$utilscfg"
  builder "<P3recoil>" "/home/$USERNAME/Lightgun/RecMono/LightgunMono3.exe.config" "$utilscfg"
  builder "<P4recoil>" "/home/$USERNAME/Lightgun/RecMono/LightgunMono4.exe.config" "$utilscfg"
  builder "<P1auto>" "/home/$USERNAME/Lightgun/RecAuto/LightgunMono1.exe.config" "$utilscfg"
  builder "<P2auto>" "/home/$USERNAME/Lightgun/RecAuto/LightgunMono2.exe.config" "$utilscfg"
  builder "<P3auto>" "/home/$USERNAME/Lightgun/RecAuto/LightgunMono3.exe.config" "$utilscfg"
  builder "<P4auto>" "/home/$USERNAME/Lightgun/RecAuto/LightgunMono4.exe.config" "$utilscfg"
  if  ! grep -Fq "[ AUTOSTART SETTINGS ]" "$utilscfg" ; then
    echo >> $utilscfg
    echo "[ AUTOSTART SETTINGS ]" >> $utilscfg
    echo >> $utilscfg
  fi
  builder "<AutostartEnable>" "0" "$utilscfg"
  builder "<RecoilTypeP1>" "silent" "$utilscfg"
  builder "<RecoilTypeP2>" "silent" "$utilscfg"
  builder "<RecoilTypeP3>" "silent" "$utilscfg"
  builder "<RecoilTypeP4>" "silent" "$utilscfg"
  builder "<RecoilReset>" "0" "$utilscfg"
  builder "<ResetTypeP1>" "silent" "$utilscfg"
  builder "<ResetTypeP2>" "silent" "$utilscfg"
  builder "<ResetTypeP3>" "silent" "$utilscfg"
  builder "<ResetTypeP4>" "silent" "$utilscfg"
  builder "<LightgunCollectionFile>" "NONE" "$utilscfg"
  builder "<SetOSReload>" "supermodel3" "$utilscfg"
  chown $USERNAME:$USERNAME $utilscfg

  if ! grep -Fq "sindenautostart.sh" "/opt/retropie/configs/all/autostart.sh" ; then
    sed -i -e "1s/^/\/home\/$USERNAME\/Lightgun\/utils\/sindenautostart.sh -r\n/" "/opt/retropie/configs/all/autostart.sh"
  fi
  if ! grep -Fq "sindenautostart.sh" "/opt/retropie/configs/all/runcommand-onlaunch.sh" ; then
    echo >> /opt/retropie/configs/all/runcommand-onlaunch.sh
    echo "/home/$USERNAME/Lightgun/utils/sindenautostart.sh -a \"\$1\" \"\$2\" \"\$3\" \"\$4\"" >> /opt/retropie/configs/all/runcommand-onlaunch.sh
  fi
  if ! grep -Fq "sindenautostart.sh" "/opt/retropie/configs/all/runcommand-onend.sh" ; then
    echo >> /opt/retropie/configs/all/runcommand-onend.sh
    echo "/home/$USERNAME/Lightgun/utils/sindenautostart.sh -x" >> "/opt/retropie/configs/all/runcommand-onend.sh"
  fi
}


function grabber(){ grep "$1" "$2" | grep -o '".*"' | sed 's/"//g' ; }


function prep() {

  if !(ls /dev/input/by-id | grep -q "SindenCam"); then
    ln -s /dev/video0 /dev/input/by-id/SindenCam
  fi

  manualstart=false
  cfgmaker
  cfg_P1_norm=$(grabber "<P1normal>" "$utilscfg")
  cfg_P1_reco=$(grabber "<P1recoil>" "$utilscfg")
  cfg_P1_auto=$(grabber "<P1auto>" "$utilscfg")
  cfg_P2_norm=$(grabber "<P2normal>" "$utilscfg")
  cfg_P2_reco=$(grabber "<P2recoil>" "$utilscfg")
  cfg_P2_auto=$(grabber "<P2auto>" "$utilscfg")
  cfg_P3_norm=$(grabber "<P3normal>" "$utilscfg")
  cfg_P3_reco=$(grabber "<P3recoil>" "$utilscfg")
  cfg_P3_auto=$(grabber "<P3auto>" "$utilscfg")
  cfg_P4_norm=$(grabber "<P4normal>" "$utilscfg")
  cfg_P4_reco=$(grabber "<P4recoil>" "$utilscfg")
  cfg_P4_auto=$(grabber "<P4auto>" "$utilscfg")
  
  cfg_enable=$(grabber "<AutostartEnable>" "$utilscfg")
  cfg_recoiltypeP1=$(grabber "<RecoilTypeP1>" "$utilscfg")
  cfg_recoiltypeP2=$(grabber "<RecoilTypeP2>" "$utilscfg")
  cfg_recoiltypeP3=$(grabber "<RecoilTypeP3>" "$utilscfg")
  cfg_recoiltypeP4=$(grabber "<RecoilTypeP4>" "$utilscfg")
  cfg_recoilreset=$(grabber "<RecoilReset>" "$utilscfg")
  cfg_resettypeP1=$(grabber "<ResetTypeP1>" "$utilscfg")
  cfg_resettypeP2=$(grabber "<ResetTypeP2>" "$utilscfg")
  cfg_resettypeP3=$(grabber "<ResetTypeP3>" "$utilscfg")
  cfg_resettypeP4=$(grabber "<ResetTypeP4>" "$utilscfg")
  cfg_collectionfile=$(grabber "<LightgunCollectionFile>" "$utilscfg")
  IFS=' ' read -r -a cfg_osr_list <<< "$(grabber "<SetOSReload>" "$utilscfg")"
}


function areyousure() {
  dialog --defaultno --title "Are you sure?" --backtitle "$backtitle" --yesno "\nAre you sure you want to $1" 10 70 3>&1 1>&2 2>&3
  echo $?
}


function applychange () { sed -i -e "/.*${2}/s/\".*\"/\"${3}\"/" ${1} ; }


function applyconfigchange () { sed -i -e "/.*${2}/s/value=\".*\"/value=\"${3}\"/" ${1} ; }


function getvalues() { grep $1 $sourcefile | grep -o 'value=".*"' | sed 's/value="//g' | sed 's/"//g' ; }


function onoffread(){ if [ $2 $1 = "1" ]; then echo "on"; else echo "off"; fi }


function onoffwrite() { if [ ! $1 = "1" ]; then echo "1"; else echo "0"; fi }



##############################
######  CONFIG EDITOR  ######
############################


function cfgprep() {
	name_P1_norm="Player1 - NoRecoil"
	name_P1_reco="Player1 - SingleRecoil"
	name_P1_auto="Player1 - AutoRecoil"
	name_P2_norm="Player2 - NoRecoil"
	name_P2_reco="Player2 - SingleRecoil"
	name_P2_auto="Player2 - AutoRecoil"
	name_P3_norm="Player3 - NoRecoil"
	name_P3_reco="Player3 - SingleRecoil"
	name_P3_auto="Player3 - AutoRecoil"
	name_P4_norm="Player4 - NoRecoil"
	name_P4_reco="Player4 - SingleRecoil"
	name_P4_auto="Player4 - AutoRecoil"
  cfg_P1_norm=$(grabber "<P1normal>" "$utilscfg")
  cfg_P1_reco=$(grabber "<P1recoil>" "$utilscfg")
  cfg_P1_auto=$(grabber "<P1auto>" "$utilscfg")
  cfg_P2_norm=$(grabber "<P2normal>" "$utilscfg")
  cfg_P2_reco=$(grabber "<P2recoil>" "$utilscfg")
  cfg_P2_auto=$(grabber "<P2auto>" "$utilscfg")
  cfg_P3_norm=$(grabber "<P3normal>" "$utilscfg")
  cfg_P3_reco=$(grabber "<P3recoil>" "$utilscfg")
  cfg_P3_auto=$(grabber "<P3auto>" "$utilscfg")
  cfg_P4_norm=$(grabber "<P4normal>" "$utilscfg")
  cfg_P4_reco=$(grabber "<P4recoil>" "$utilscfg")
  cfg_P4_auto=$(grabber "<P4auto>" "$utilscfg")
}


function filecheck() {
  if ! test -f "$1"; then
    dialog --title "$title" --backtitle "$backtitle" --msgbox "\nThe selected file doesn't exist.\n\n$1" 10 70 3>&1 1>&2 2>&3
    echo "no"
  else
    echo "yes"
  fi
}


function radiocomparison()  { if [ $1 = $2 ]; then echo "on"; else echo "off"; fi }


function rangeentry(){
  local title="$1"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --rangebox \
  "\nSet the value of the $1.\n\n$5(Current setting : $4)" \
  11 50 $2 $3 $4 3>&1 1>&2 2>&3 )
    echo $selection
}


function captivedialog { # usage: captivedialog [duration(s)] [height] [width] [message] [title]
  local count=$1+1
  local percent
  local yn
  (( ++count )) 
  ( while :; do
      cat <<-EOF      # The "-" here allows EOF later to be indented with TAB
        $percent
	EOF
      (( count-=1 ))  # This can only be indented with TAB
      percent=$((100/$1*($1+2-$count)))
      [ $count -eq 0 ] && break
      sleep 0.1
    done ) |
    dialog --title "$5" --gauge "$4" $2 $3 $percent
    dialog --title "$5" --yes-label " OK " --no-label " Go Back " --yesno "$4" $2 $3
    captivereturn=$?
}


function choosefile() { # [title] [message]
  local selection
  local choicecfg
  local choicename
  local yn
  local destfile
  selfile=""
  selname=""
       
  selection=$(dialog --title "$1" --backtitle "$backtitle" --menu "$2" 22 70 18 \
      "1"   "$name_P1_norm" \
      "2"   "$name_P1_reco" \
      "3"   "$name_P1_auto" \
      "4"   "$name_P2_norm" \
      "5"   "$name_P2_reco" \
      "6"   "$name_P2_auto" \
      "7"   "$name_P3_norm" \
      "8"   "$name_P3_reco" \
      "9"   "$name_P3_auto" \
      "10"  "$name_P4_norm" \
      "11"  "$name_P4_reco" \
      "12"  "$name_P4_auto" \
      3>&1 1>&2 2>&3 )
      case "$selection" in
          1)   choicecfg=$cfg_P1_norm ;  choicename=$name_P1_norm ;;
          2)   choicecfg=$cfg_P1_reco ;  choicename=$name_P1_reco ;;
          3)   choicecfg=$cfg_P1_auto ;  choicename=$name_P1_auto ;;
          4)   choicecfg=$cfg_P2_norm ;  choicename=$name_P2_norm ;;
          5)   choicecfg=$cfg_P2_reco ;  choicename=$name_P2_reco ;;
          6)   choicecfg=$cfg_P2_auto ;  choicename=$name_P2_auto ;;
          7)   choicecfg=$cfg_P3_norm ;  choicename=$name_P3_norm ;;
          8)   choicecfg=$cfg_P3_reco ;  choicename=$name_P3_reco ;;
          9)   choicecfg=$cfg_P3_auto ;  choicename=$name_P3_auto ;;
          10)  choicecfg=$cfg_P4_norm ;  choicename=$name_P4_norm ;;
          11)  choicecfg=$cfg_P4_reco ;  choicename=$name_P4_reco ;;
          12)  choicecfg=$cfg_P4_auto ;  choicename=$name_P4_auto ;;
          *)   return ;;
        esac
     if ! [ "$choicename" = "" ]; then
       dialog --title "Your Selection..." --msgbox "\n$choicename\n$choicecfg" 10 70
       selfile="$choicecfg"
       selname="$choicename"
     else
       dialog --title "Your Selection..." --msgbox "\nVoid config selected. Cancelling" 10 70
       selfile=""
       selname=""
       return
     fi
}


function settingstransfer() {
  local title
  local selection
  local yn
  local destname
  local destfile
  title="Destination for $1 Settings Transfer"
  choosefile "$title" "\nChoose Which config file you would like to copy these settings into.\n\nBe careful to make the correct selection and ensure that you have made backups of your configs."
  destfile=$selfile
  destname=$selname
     if ! [ "$destname" = "" ]; then
         settingstransfer_2 "$1" "$sourcefile" "$destfile"
     else
       return
     fi
}


function settingstransfer_2() { 
local yn
yn=$(areyousure "go through with this transfer?")
  if [ $yn == "0" ]; then
    case "$1" in
      "Button Map") 
         buttonprep
         savebuttons $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      "Recoil")
         recoilprep
         saverecoil $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      "Camera")
         cameraprep
         savecamera $3
         dialog --title "$1" --backtitle "$backtitle" --no-cancel --msgbox "\nTransfer Complete"  7 22
         ;;
      *) dialog --msgbox "ERROR"  15 70 ;;
    esac
  else
    dialog --msgbox "\nTransfer Cancelled"  7 23
  fi  
}



#########################
#  Recoil
#########################


function saverecoil() {
  applyconfigchange $1 $s_agreeterms     $v_agreeterms    
  applyconfigchange $1 $s_enablerecoil   $v_enablerecoil

  applyconfigchange $1 $s_rectrigger     $v_rectrigger
  applyconfigchange $1 $s_rectriggeros   $v_rectriggeros
  applyconfigchange $1 $s_recpumpon      $v_recpumpon   
  applyconfigchange $1 $s_recpumpoff     $v_recpumpoff  

  applyconfigchange $1 $s_recfl          $v_recfl
  applyconfigchange $1 $s_recfr          $v_recfr
  applyconfigchange $1 $s_recbl          $v_recbl
  applyconfigchange $1 $s_recbr          $v_recbr

  applyconfigchange $1 $s_singlestrength $v_singlestrength
  applyconfigchange $1 $s_recoiltype     $v_recoiltype
  applyconfigchange $1 $s_autostrength   $v_autostrength
  applyconfigchange $1 $s_autodelay      $v_autodelay
  applyconfigchange $1 $s_autopulse      $v_autopulse
}


function recoilprep() {
  s_agreeterms="\"IAgreeRecoilTermsInLicense\"" ;  v_agreeterms="0"
  s_enablerecoil="\"EnableRecoil\""             ;  v_enablerecoil=$(getvalues $s_enablerecoil)

  s_rectrigger="\"RecoilTrigger\""              ;  v_rectrigger=$(getvalues $s_rectrigger)
  s_rectriggeros="\"RecoilTriggerOffscreen\""   ;  v_rectriggeros=$(getvalues $s_rectriggeros)
  s_recpumpon="\"RecoilPumpActionOnEvent\""     ;  v_recpumpon=$(getvalues $s_recpumpon)
  s_recpumpoff="\"RecoilPumpActionOffEvent\""   ;  v_recpumpoff=$(getvalues $s_recpumpoff)

  s_recfl="\"RecoilFrontLeft\""                 ;  v_recfl=$(getvalues $s_recfl)
  s_recfr="\"RecoilFrontRight\""                ;  v_recfr=$(getvalues $s_recfr)
  s_recbl="\"RecoilBackLeft\""                  ;  v_recbl=$(getvalues $s_recbl)
  s_recbr="\"RecoilBackRight\""                 ;  v_recbr=$(getvalues $s_recbr)

  s_singlestrength="\"RecoilStrength\""         ;  v_singlestrength=$(getvalues $s_singlestrength)

  s_recoiltype="\"TriggerRecoilNormalOrRepeat\"";  v_recoiltype=$(getvalues $s_recoiltype)

  s_autostrength="\"AutoRecoilStrength\""       ;  v_autostrength=$(getvalues $s_autostrength)
  s_autodelay="\"AutoRecoilStartDelay\""        ;  v_autodelay=$(getvalues $s_autodelay)
  s_autopulse="\"AutoRecoilDelayBetweenPulses\"";  v_autopulse=$(getvalues $s_autopulse)
}


function termsandcond(){ 
  local licensetxt
  local title
  licensetxt="/home/$USERNAME/Lightgun/utils/recoiltcs.txt"
  title="Recoil Terms and Conditions"
  dialog --defaultno --scrollbar --yes-label " Accept " --no-label " Cancel " \
    --title "$title" --backtitle "$backtitle" --yesno "$(head -c 3K $licensetxt)"  35 70 3>&1 1>&2 2>&3
  local RET=$?
  if [ $RET -eq 0 ]; then
    v_agreeterms=1
    recoilmenuitem=3
    return 0
  else
    recoilmenuitem=9
  fi  
}


function recoilvalues() {
  local title
  local selection
  title="Recoil Type and Intensity Values"
  if [ $v_recoiltype == "0" ]; then
    n_recoiltype="Single";
  elif [ $v_recoiltype == "1" ]; then
    n_recoiltype="Auto";
  else
    n_recoiltype="unknown"
  fi
  selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
    "\nChoose which setting you want to edit.\nThe current value is shown alongside the option." \
    20 70 7 \
      "1"  "Recoil Type ($n_recoiltype)" \
      "2"  "Single Recoil Strength ($v_singlestrength)" \
      "3"  "Auto Recoil Strength ($v_autostrength)" \
      "4"  "Auto Start Delay ($v_autodelay)" \
      "5"  "Auto Pulse Delay ($v_autopulse)" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1)
        f_recoiltype
	recoilmenuitem=5
      ;;
      2)
        v_singlestrength=$(rangeentry "Single-Shot Recoil" 0 100 $v_singlestrength \
          "Note that higher values drain the capacitor quicker and will take longer to recharge.\n\n")
	recoilmenuitem=5
      ;;
      3)
        v_autostrength=$(rangeentry "Automatic Recoil" 0 100 $v_autostrength \
          "Note that higher values drain the capacitor quicker and will take longer to recharge.\n\n")
	recoilmenuitem=5
      ;;
      4)
        v_autodelay=$(rangeentry "Automatic Recoil Start Delay" 0 30000 $v_autodelay \
          "This is the time between the first recoil and the subsequent repeated pulse\n\n")
	recoilmenuitem=5
      ;;
      5)
        v_autopulse=$(rangeentry "Automatic Recoil Pulse Delay" 0 30000 $v_autopulse \
          "This is the time between the first recoil and the subsequent repeated pulse\n\nNote that more rapid recoil (lower values) can drain the capacitor quicker if it has insufficient time to recharge.\n\n")
	recoilmenuitem=5
      ;;
      *)
	recoilmenuitem=3
      ;;
    esac
}


function f_recoiltype(){
  local title
  local selection
  title="Recoil Type"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --radiolist \
    "\nChoose the type of recoil you want to use.\nCurrent setting : $n_recoiltype" \
    20 70 2\
      "1"  "Single" $(onoffread $v_recoiltype !) \
      "2"  "Auto"   $(onoffread $v_recoiltype) \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_recoiltype="0" ;;
      2) v_recoiltype="1" ;;
    esac
}


function recoilbuttons(){
  local title
  local selection
  title="Buttons That Use Recoil"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --nocancel --checklist \
    "\nChoose which buttons will cause the recoil solenoid to fire." \
    20 70 8 \
      "1"  "Trigger"             $(onoffread $v_rectrigger) \
      "2"  "Trigger offscreen"   $(onoffread $v_rectriggeros) \
      "3"  "Pump"                $(onoffread $v_recpumpon) \
      "4"  "Pump Release"        $(onoffread $v_recpumpoff) \
      "5"  "Front Left"          $(onoffread $v_recfl) \
      "6"  "Front Right"         $(onoffread $v_recfr) \
      "7"  "Back Left"           $(onoffread $v_recbl) \
      "8"  "Back Right"          $(onoffread $v_recbr) \
      3>&1 1>&2 2>&3 )
  if grep -q "1" <<< "$selection"; then v_rectrigger="1";   else v_rectrigger="0";   fi
  if grep -q "2" <<< "$selection"; then v_rectriggeros="1"; else v_rectriggeros="0"; fi
  if grep -q "3" <<< "$selection"; then v_recpumpon="1";    else v_recpumpon="0"; fi
  if grep -q "4" <<< "$selection"; then v_recpumpoff="1";   else v_recpumpoff="0"; fi
  if grep -q "5" <<< "$selection"; then v_recfl="1";        else v_recfl="0"; fi
  if grep -q "6" <<< "$selection"; then v_recfr="1";        else v_recfr="0"; fi
  if grep -q "7" <<< "$selection"; then v_recbl="1";        else v_recbl="0"; fi
  if grep -q "8" <<< "$selection"; then v_recbr="1";        else v_recbr="0"; fi
}


function recoilmenu(){
  local title
  local selection
  local yn
  title="Recoil Settings"
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
      "\n$sourcename\n\n$sourcefile\n\nWhich recoil settings would you like to view and edit?" \
      20 70 6 \
      "1"  "Enable/disable recoil ($(onoffread $v_enablerecoil))" \
      "2"  "Enable/disable which buttons should use recoil." \
      "3"  "Recoil type and intensity." \
      "4"  "Transfer this file's settings to another config file" \
      "5"  "Save changes and exit." \
      "6"  "Withdraw agreement to the terms of use." \
      3>&1 1>&2 2>&3 )
        case "$selection" in
          1) v_enablerecoil=$(onoffwrite $v_enablerecoil) ;;
          2) recoilmenuitem=4 ;;
          3) recoilmenuitem=5 ;;
          4) settingstransfer "Recoil" ;;
          5) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               saverecoil $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nRecoil changes have been saved for $sourcename." 12 78
               recoilmenuitem=9
             else
               recoilmenuitem=3
             fi ;;
          6) yn=$(areyousure "withdraw your agreement to the terms of the licence? This will disable recoil functionality.")
             if [ $yn == "0" ]; then
               applyconfigchange $sourcefile $s_agreeterms 0 
               recoilprep
               saverecoil
               recoilmenuitem=2
             else
               recoilmenuitem=3
             fi ;;
          *) recoilmenuitem=9
        esac
}


function recoilchoosefile() {
  local title
  local selection
  title="Recoil Config File Selection"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         recoilmenuitem=1
     else
         recoilmenuitem=9
     fi
}


function recoilmain(){
  recoilmenuitem=0
  while ! [[ $recoilmenuitem -eq 9 ]]; do
    case "$recoilmenuitem" in
      0) recoilchoosefile ;;
      1) recoilprep
         recoilmenuitem=2 ;;
      2) termsandcond ;;
      3) recoilmenu ;;
      4) recoilbuttons
         recoilmenuitem=3 ;;
      5) recoilvalues ;;
      *) return ;;
    esac
  done
}



#########################
#  Camera
#########################


function cameraprep() {
  s_brightness="\"CameraBrightness\""      ;  v_brightness=$(getvalues $s_brightness)
  s_contrast="\"CameraContrast\""          ;  v_contrast=$(getvalues $s_contrast)
  s_expauto="\"CameraExposureAuto\""       ;  v_expauto=$(getvalues $s_expauto)
  s_exposure="\"CameraExposure\""          ;  v_exposure=$(getvalues $s_exposure)
  s_colourrange="\"ColourMatchRange\""     ;  v_colourrange=$(getvalues $s_colourrange)
  #s_saturation="\"CameraSaturation\""      ;  v_saturation=$(getvalues $s_saturation)
  #s_whiteauto="\"CameraWhiteBalanceAuto\"" ;  v_whiteauto=$(getvalues $s_whiteauto)
  #s_whitebalance="\"CameraWhiteBalance\""  ;  v_whitebalance=$(getvalues $s_whitebalance)
}


function savecamera() {
  applyconfigchange $1 $s_brightness     $v_brightness
  applyconfigchange $1 $s_contrast       $v_contrast  
  applyconfigchange $1 $s_expauto        $v_expauto   
  applyconfigchange $1 $s_exposure       $v_exposure  
  applyconfigchange $1 $s_colourrange    $v_colourrange
  #applyconfigchange $1 $s_saturation     $v_saturation
  #applyconfigchange $1 $s_whiteauto      $v_whiteauto  
  #applyconfigchange $1 $s_whitebalance   $v_whitebalance
}


function cameramenu() {
  local title
  local selection
  local yn
  title="Camera Settings"
  if [ $v_expauto = "1" ]; then v_exposure=""; fi
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
    "\nChoose which setting you want to edit.\nThe current value is shown alongside the option." \
    20 70 10 \
      "1"  "Brightness ($v_brightness)" \
      "2"  "Contrast ($v_contrast)" \
      "3"  "Auto Exposure ($(onoffread $v_expauto))" \
      "4"  "Manual Exposure ($v_exposure)" \
      "5"  "Colour Match Range ($v_colourrange)" \
      "6"  "Transfer this file's settings to another config file" \
      "7"  "Save changes" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_brightness=$(rangeentry "Camera Brightness" 0 255 $v_brightness) ;;
      2) v_contrast=$(rangeentry "Camera Contrast" 0 127 $v_contrast) ;;
      3) v_expauto=$(onoffwrite $v_expauto) ;;
      4) if [ $v_expauto = "0" ]; then 
           if [ -z "$v_exposure" ]; then v_exposure="-5"; fi
           v_exposure=$(rangeentry "Camera Manual Exposure" -9 0 $v_exposure "This value will be blank if Auto Exposure is on.\n\n")
         fi ;;
      5) v_colourrange=$(rangeentry "Camera Colour Match Range" 0 512 $v_colourrange "Slight increases to this value can sometimes help with border recognition.\n\n") ;;
      6) settingstransfer "Camera" ;;
      7) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               savecamera $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nCamera changes have been saved for $sourcename." 12 78
               cameramenuitem=9
             fi ;;
      *) cameramenuitem=9
         return ;;
    esac
}


function camerachoosefile(){
  local title
  local selection
  title="Camera Config File Selection ($1)"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         cameramenuitem=1
     else
         cameramenuitem=9
     fi
}


function cameramain(){
  cameramenuitem=0
  while ! [[ $cameramenuitem -eq 9 ]]; do
    case "$cameramenuitem" in
      0) camerachoosefile ;;
      1) cameraprep
         cameramenuitem=5 ;;
      5) cameramenu;;
     9|*) return ;;
    esac
  done
}



#########################
#  Buttons
#########################


function buttonprep() {
  s_ontrigger="\"ButtonTrigger\""           ;   v_ontrigger=$(getvalues $s_ontrigger)
  s_onpump="\"ButtonPumpAction\""           ;   v_onpump=$(getvalues $s_onpump)
  s_onfl="\"ButtonFrontLeft\""              ;   v_onfl=$(getvalues $s_onfl)
  s_onbl="\"ButtonRearLeft\""               ;   v_onbl=$(getvalues $s_onbl)
  s_onfr="\"ButtonFrontRight\""             ;   v_onfr=$(getvalues $s_onfr)
  s_onbr="\"ButtonRearRight\""              ;   v_onbr=$(getvalues $s_onbr)
  s_onup="\"ButtonUp\""                     ;   v_onup=$(getvalues $s_onup)
  s_ondown="\"ButtonDown\""                 ;   v_ondown=$(getvalues $s_ondown)
  s_onleft="\"ButtonLeft\""                 ;   v_onleft=$(getvalues $s_onleft)
  s_onright="\"ButtonRight\""               ;   v_onright=$(getvalues $s_onright)

  s_onmodtrigger="\"TriggerMod\""           ;   v_onmodtrigger=$(getvalues $s_onmodtrigger)
  s_onmodpump="\"PumpActionMod\""           ;   v_onmodpump=$(getvalues $s_onmodpump)
  s_onmodfl="\"FrontLeftMod\""              ;   v_onmodfl=$(getvalues $s_onmodfl)
  s_onmodbl="\"RearLeftMod\""               ;   v_onmodbl=$(getvalues $s_onmodbl)
  s_onmodfr="\"FrontRightMod\""             ;   v_onmodfr=$(getvalues $s_onmodfr)
  s_onmodbr="\"RearRightMod\""              ;   v_onmodbr=$(getvalues $s_onmodbr)
  s_onmodup="\"UpMod\""                     ;   v_onmodup=$(getvalues $s_onmodup)
  s_onmoddown="\"DownMod\""                 ;   v_onmoddown=$(getvalues $s_onmoddown)
  s_onmodleft="\"LeftMod\""                 ;   v_onmodleft=$(getvalues $s_onmodleft)
  s_onmodright="\"RightMod\""               ;   v_onmodright=$(getvalues $s_onmodright)

  s_offtrigger="\"ButtonTriggerOffscreen\"" ;   v_offtrigger=$(getvalues $s_offtrigger)
  s_offpump="\"ButtonPumpActionOffscreen\"" ;   v_offpump=$(getvalues $s_offpump)
  s_offfl="\"ButtonFrontLeftOffscreen\""    ;   v_offfl=$(getvalues $s_offfl)
  s_offbl="\"ButtonRearLeftOffscreen\""     ;   v_offbl=$(getvalues $s_offbl)
  s_offfr="\"ButtonFrontRightOffscreen\""   ;   v_offfr=$(getvalues $s_offfr)
  s_offbr="\"ButtonRearRightOffscreen\""    ;   v_offbr=$(getvalues $s_offbr)
  s_offup="\"ButtonUpOffscreen\""           ;   v_offup=$(getvalues $s_offup)
  s_offdown="\"ButtonDownOffscreen\""       ;   v_offdown=$(getvalues $s_offdown)
  s_offleft="\"ButtonLeftOffscreen\""       ;   v_offleft=$(getvalues $s_offleft)
  s_offright="\"ButtonRightOffscreen\""     ;   v_offright=$(getvalues $s_offright)

  s_offmodtrigger="\"TriggerOffscreenMod\"" ;   v_offmodtrigger=$(getvalues $s_offmodtrigger)
  s_offmodpump="\"PumpActionOffscreenMod\"" ;   v_offmodpump=$(getvalues $s_offmodpump)
  s_offmodfl="\"FrontLeftOffscreenMod\""    ;   v_offmodfl=$(getvalues $s_offmodfl)
  s_offmodbl="\"RearLeftOffscreenMod\""     ;   v_offmodbl=$(getvalues $s_offmodbl)
  s_offmodfr="\"FrontRightOffscreenMod\""   ;   v_offmodfr=$(getvalues $s_offmodfr)
  s_offmodbr="\"RearRightOffscreenMod\""    ;   v_offmodbr=$(getvalues $s_offmodbr)
  s_offmodup="\"UpOffscreenMod\""           ;   v_offmodup=$(getvalues $s_offmodup)
  s_offmoddown="\"DownOffscreenMod\""       ;   v_offmoddown=$(getvalues $s_offmoddown)
  s_offmodleft="\"LeftOffscreenMod\""       ;   v_offmodleft=$(getvalues $s_offmodleft)
  s_offmodright="\"RightOffscreenMod\""     ;   v_offmodright=$(getvalues $s_offmodright)

  s_enableoffscreen="\"OffscreenReload\""   ;   v_enableoffscreen=$(getvalues $s_enableoffscreen=)
}


function savebuttons() { 
  applyconfigchange $1 $s_ontrigger $v_ontrigger
  applyconfigchange $1 $s_onpump $v_onpump
  applyconfigchange $1 $s_onfl $v_onfl
  applyconfigchange $1 $s_onbl $v_onbl
  applyconfigchange $1 $s_onfr $v_onfr
  applyconfigchange $1 $s_onbr $v_onbr
  applyconfigchange $1 $s_onup $v_onup
  applyconfigchange $1 $s_ondown $v_ondown
  applyconfigchange $1 $s_onleft $v_onleft
  applyconfigchange $1 $s_onright $v_onright
  applyconfigchange $1 $s_onmodtrigger $v_onmodtrigger
  applyconfigchange $1 $s_onmodpump $v_onmodpump
  applyconfigchange $1 $s_onmodfl $v_onmodfl
  applyconfigchange $1 $s_onmodbl $v_onmodbl
  applyconfigchange $1 $s_onmodfr $v_onmodfr
  applyconfigchange $1 $s_onmodbr $v_onmodbr
  applyconfigchange $1 $s_onmodup $v_onmodup
  applyconfigchange $1 $s_onmoddown $v_onmoddown
  applyconfigchange $1 $s_onmodleft $v_onmodleft
  applyconfigchange $1 $s_onmodright $v_onmodright
  applyconfigchange $1 $s_offtrigger $v_offtrigger
  applyconfigchange $1 $s_offpump $v_offpump
  applyconfigchange $1 $s_offfl $v_offfl
  applyconfigchange $1 $s_offbl $v_offbl
  applyconfigchange $1 $s_offfr $v_offfr
  applyconfigchange $1 $s_offbr $v_offbr
  applyconfigchange $1 $s_offup $v_offup
  applyconfigchange $1 $s_offdown $v_offdown
  applyconfigchange $1 $s_offleft $v_offleft
  applyconfigchange $1 $s_offright $v_offright
  applyconfigchange $1 $s_offmodtrigger $v_offmodtrigger
  applyconfigchange $1 $s_offmodpump $v_offmodpump
  applyconfigchange $1 $s_offmodfl $v_offmodfl
  applyconfigchange $1 $s_offmodbl $v_offmodbl
  applyconfigchange $1 $s_offmodfr $v_offmodfr
  applyconfigchange $1 $s_offmodbr $v_offmodbr
  applyconfigchange $1 $s_offmodup $v_offmodup
  applyconfigchange $1 $s_offmoddown $v_offmoddown
  applyconfigchange $1 $s_offmodleft $v_offmodleft
  applyconfigchange $1 $s_offmodright $v_offmodright
}


function buttonselector(){
  local title
  local selection
  title="Button Action Selection for $1 "
  while :; do
    selection=$(dialog --no-cancel --title "$title" --backtitle "$backtitle" --radiolist \
      "\nWhat action would you like the $1 button to do?\n\nCurrent setting : $2"  \
      20 70 10 \
      "0"   "VOID"            "$(radiocomparison $2 "0")" \
      "1"   "MOUSE 1"         "$(radiocomparison $2 "1")" \
      "2"   "MOUSE 2"         "$(radiocomparison $2 "2")" \
      "3"   "MOUSE 3"         "$(radiocomparison $2 "3")" \
      "7"   "Left ALT"        "$(radiocomparison $2 "7")" \
      "8"   "Num 0"           "$(radiocomparison $2 "8")" \
      "9"   "Num 1"           "$(radiocomparison $2 "9")" \
      "10"  "Num 2"           "$(radiocomparison $2 "10")" \
      "11"  "Num 3"           "$(radiocomparison $2 "11")" \
      "12"  "Num 4"           "$(radiocomparison $2 "12")" \
      "13"  "Num 5"           "$(radiocomparison $2 "13")" \
      "14"  "Num 6"           "$(radiocomparison $2 "14")" \
      "15"  "Num 7"           "$(radiocomparison $2 "15")" \
      "16"  "Num 8"           "$(radiocomparison $2 "16")" \
      "17"  "Num 9"           "$(radiocomparison $2 "17")" \
      "18"  "Left SHIFT"      "$(radiocomparison $2 "18")" \
      "44"  "a"               "$(radiocomparison $2 "44")" \
      "45"  "b"               "$(radiocomparison $2 "45")" \
      "46"  "c"               "$(radiocomparison $2 "46")" \
      "47"  "d"               "$(radiocomparison $2 "47")" \
      "48"  "e"               "$(radiocomparison $2 "48")" \
      "49"  "f"               "$(radiocomparison $2 "49")" \
      "50"  "g"               "$(radiocomparison $2 "50")" \
      "51"  "h"               "$(radiocomparison $2 "51")" \
      "52"  "i"               "$(radiocomparison $2 "52")" \
      "53"  "j"               "$(radiocomparison $2 "53")" \
      "54"  "k"               "$(radiocomparison $2 "54")" \
      "55"  "l"               "$(radiocomparison $2 "55")" \
      "56"  "m"               "$(radiocomparison $2 "56")" \
      "57"  "n"               "$(radiocomparison $2 "57")" \
      "58"  "o"               "$(radiocomparison $2 "58")" \
      "59"  "p"               "$(radiocomparison $2 "59")" \
      "60"  "q"               "$(radiocomparison $2 "60")" \
      "61"  "r"               "$(radiocomparison $2 "61")" \
      "62"  "s"               "$(radiocomparison $2 "62")" \
      "63"  "t"               "$(radiocomparison $2 "63")" \
      "64"  "u"               "$(radiocomparison $2 "64")" \
      "65"  "v"               "$(radiocomparison $2 "65")" \
      "66"  "w"               "$(radiocomparison $2 "66")" \
      "67"  "x"               "$(radiocomparison $2 "67")" \
      "68"  "y"               "$(radiocomparison $2 "68")" \
      "69"  "z"               "$(radiocomparison $2 "69")" \
      "70"  "ENTER"           "$(radiocomparison $2 "70")" \
      "71"  "SPACE"           "$(radiocomparison $2 "71")" \
      "72"  "ESC"             "$(radiocomparison $2 "72")" \
      "73"  "TAB"             "$(radiocomparison $2 "73")" \
      "74"  "UP"              "$(radiocomparison $2 "74")" \
      "75"  "DOWN"            "$(radiocomparison $2 "75")" \
      "76"  "LEFT"            "$(radiocomparison $2 "76")" \
      "77"  "RIGHT"           "$(radiocomparison $2 "77")" \
      "78"  "\"=\" (equals)"  "$(radiocomparison $2 "78")" \
      "79"  "\",\" (comma)"   "$(radiocomparison $2 "79")" \
      "80"  "\"-\" (minus)"   "$(radiocomparison $2 "80")" \
      "81"  "\".\" (dot)"     "$(radiocomparison $2 "81")" \
      "82"  "F1"              "$(radiocomparison $2 "82")" \
      "83"  "F2"              "$(radiocomparison $2 "83")" \
      "84"  "F3"              "$(radiocomparison $2 "84")" \
      "85"  "F4"              "$(radiocomparison $2 "85")" \
      "86"  "F5"              "$(radiocomparison $2 "86")" \
      "87"  "F6"              "$(radiocomparison $2 "87")" \
      "88"  "F7"              "$(radiocomparison $2 "88")" \
      "89"  "F8"              "$(radiocomparison $2 "89")" \
      "90"  "F9"              "$(radiocomparison $2 "90")" \
      "91"  "F10"             "$(radiocomparison $2 "91")" \
      "92"  "F11"             "$(radiocomparison $2 "92")" \
      "93"  "F12"             "$(radiocomparison $2 "93")" \
      3>&1 1>&2 2>&3 )
    if ((selection >= 0 && selection <= 93)); then
      echo $selection
      return
    fi
  done
}


function buttonsonscreen() {
  local title
  local selection
  title="Button Mapping for Normal (On-Screen) Actions"
  while :; do
    selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
      "\nChoose which button you want to edit.\nThe current value is shown alongside the option." \
      20 70 10 \
        "1"  "Trigger ($v_ontrigger)" \
        "2"  "Pump ($v_onpump)" \
        "3"  "Front Left ($v_onfl)" \
        "4"  "Rear Left ($v_onbl)" \
        "5"  "Front Right ($v_onfr)" \
        "6"  "Rear Right ($v_onbr)" \
        "7"  "D-Pad Up ($v_onup)" \
        "8"  "D-Pad Down ($v_ondown)" \
        "9"  "D-Pad Left ($v_onleft)" \
       "10"  "D-Pad Right ($v_onright)" \
        3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_ontrigger=$(buttonselector "Trigger (normal)" "$v_ontrigger") ;;
      2) v_onpump=$(buttonselector "Pump (normal)" $v_onpump) ;;
      3) v_onfl=$(buttonselector "Front Left (normal)" $v_onfl) ;;
      4) v_onbl=$(buttonselector "Back Left (normal)" $v_onbl) ;;
      5) v_onfr=$(buttonselector "Front Right (normal)" $v_onfr) ;;
      6) v_onbr=$(buttonselector "Back Right (normal)" $v_onbr) ;;
      7) v_onup=$(buttonselector "D-Pad Up (normal)" $v_onup) ;;
      8) v_ondown=$(buttonselector "D-Pad Down (normal)" $v_ondown) ;;
      9) v_onleft=$(buttonselector "D-Pad Left (normal)" $v_onleft) ;;
      10) v_onright=$(buttonselector "D-Pad Right (normal)" $v_onright) ;;
      *) return ;;
    esac
  done
}


function buttonsoffscreen() {
  local title
  local selection
  title="Button Mapping for Off-Screen Actions"
  while :; do
    selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
      "\nChoose which button you want to edit.\nThe current value is shown alongside the option." \
      20 70 10 \
        "1"  "Trigger ($v_offtrigger)" \
        "2"  "Pump ($v_offpump)" \
        "3"  "Front Left ($v_offfl)" \
        "4"  "Rear Left ($v_offbl)" \
        "5"  "Front Right ($v_offfr)" \
        "6"  "Rear Right ($v_offbr)" \
        "7"  "D-Pad Up ($v_offup)" \
        "8"  "D-Pad Down ($v_offdown)" \
        "9"  "D-Pad Left ($v_offleft)" \
       "10"  "D-Pad Right ($v_offright)" \
        3>&1 1>&2 2>&3 )
    case "$selection" in
      1) v_offtrigger=$(buttonselector "Trigger (off-screen)" "$v_offtrigger") ;;
      2) v_offpump=$(buttonselector "Pump (off-screen)" $v_offpump) ;;
      3) v_offfl=$(buttonselector "Front Left (off-screen)" $v_offfl) ;;
      4) v_offbl=$(buttonselector "Back Left (off-screen)" $v_offbl) ;;
      5) v_offfr=$(buttonselector "Front Right (off-screen)" $v_offfr) ;;
      6) v_offbr=$(buttonselector "Back Right (off-screen)" $v_offbr) ;;
      7) v_offup=$(buttonselector "D-Pad Up (off-screen)" $v_offup) ;;
      8) v_offdown=$(buttonselector "D-Pad Down (off-screen)" $v_offdown) ;;
      9) v_offleft=$(buttonselector "D-Pad Left (off-screen)" $v_offleft) ;;
      10) v_offright=$(buttonselector "D-Pad Right (off-screen)" $v_offright) ;;
      *) return ;;
    esac
  done
}


function buttononoffmenu(){
  local title
  local selection
  local yn
  title="Button Mapping On/Off-Screen Group Selection"
  selection=$(dialog --cancel-label " Quit without saving " --title "$title" --backtitle "$backtitle" --menu \
      "\nWhich button settings group would you like to view and edit?" \
      20 70 5 \
      "1"  "Normal button actions" \
      "2"  "Enable/Disable off-screen actions ($(onoffread $v_enableoffscreen))" \
      "3"  "Off-screen button actions" \
      "4"  "Transfer this file's settings to another config file" \
      "5"  "Save changes and exit" \
      3>&1 1>&2 2>&3 )
        case "$selection" in
          1) buttonsonscreen ;;
          2) v_enableoffscreen=$(onoffwrite $v_enableoffscreen) ;;
          3) buttonsoffscreen ;;
          4) settingstransfer "Button Map" ;;
          5) yn=$(areyousure "overwrite your $sourcename config file with the selections you have made?")
             if [ $yn == "0" ]; then
               savebuttons $sourcefile
               dialog --backtitle "$backtitle" --title "Save Complete" --msgbox "\nButton mapping changes have been saved for $sourcename." 12 78
               buttonmenuitem=9
             else
               buttonmenuitem=2
             fi ;;
          *) buttonmenuitem=9; return ;;
        esac
}


function buttonchoosefile(){
  local title
  local selection
  title="Button Config File Selection ($1)"
  choosefile "$title" "\nWhich config file would you like to view and edit?"
  sourcefile=$selfile
  sourcename=$selname
     if ! [ "$sourcename" = "" ] && [ $(filecheck $sourcefile) == "yes" ]; then
         buttonmenuitem=1
     else
         buttonmenuitem=9
     fi
}


function buttonmain(){
  buttonmenuitem=8
  while ! [[ $buttonmenuitem -eq 9 ]]; do
    case "$buttonmenuitem" in
#      0) buttonchoosegroup ;;
      0) buttonchoosefile ;;
      1) buttonprep
         buttonmenuitem=2 ;;
      2) buttononoffmenu;;
      8) captivedialog 50 15 50  "\nEditing the button mapping may lead to loss of functions in games if they have been pre-configured with the existing settings in mind.\n\nProceed only if you have made backups of your configs and you know what you are doing," "CAUTION!"
         case "$captivereturn" in
           0) ;;
           1|*) return ;;
         esac
         buttonmenuitem=0 ;;
     9|*) return ;;
    esac
  done
}



#########################
#  Backup
#########################


function restorebackup() {
  local title
  local selection
  local yn
  local originalfile
  local originalname
  title="Restore a Backup"
  choosefile "$title" "\nWhich $1 config file would you like to restore from backup?"
  originalfile=$selfile
  originalname=$selname
  if ! [ "$originalname" = "" ] && [ $(filecheck $originalfile.backup) == "yes" ]; then
      yn=$(areyousure "overwrite this file with the backup?\n\n$originalfile")
      if [ $yn = "0" ]; then
        cp -pf "$originalfile.backup" "$originalfile"
        dialog --title "$title" --msgbox "\nRestore of $originalfile from backup completed" 10 70
      fi
    fi
  backupmenuitem=0
}


function makebackup(){
  local title
  local selection
  local yn
  local originalfile
  local originalname
  title="Make a Backup"
  choosefile "$title" "\nWhich $1 config file would you like to backup?"
  originalfile=$selfile
  originalname=$selname
  if ! [ "$originalname" = "" ] && [ $(filecheck $originalfile) == "yes" ]; then
      yn=$(areyousure "make a backup of this file?\n If a backup with the extenstion \".backup\" already exists, it will be replaced.")
      if [ $yn = "0" ]; then
        cp -pf "$originalfile" "$originalfile.backup"
        dialog --title "$title" --msgbox "\nBackup of $originalfile completed" 10 70
      fi
    fi
  backupmenuitem=0
}


function backupmenu() {
  local title
  local selection
  title="Backup & Restore"
  selection=$(dialog --title "$title" --backtitle "$backtitle" --menu \
    "\nWhat do you want to do?" \
    20 70 2 \
      "1"  "Backup" \
      "2"  "Restore" \
      3>&1 1>&2 2>&3 )
    case "$selection" in
      1) makebackup ;;
      2) restorebackup ;;
      *) backupmenuitem=9
         return ;;
    esac
}


function backupmain(){
  backupmenuitem=0
  while ! [[ $backupmenuitem -eq 9 ]]; do
    case "$backupmenuitem" in
      0) backupmenu ;;
      9|*) return ;;
    esac
  done
}



#########################
#  CFG Edit Main
#########################


function cfgeditmenu(){
  cfgprep
  local title
  local selection
  while :; do
    title="Sinden Lightgun Config Editor"
    selection=$(dialog --cancel-label " Exit " --title "$title" --backtitle "$backtitle" --menu \
        "\nWhat config elements would you like to view and edit?" \
        20 70 4 \
        "1"  "Recoil" \
        "2"  "Camera" \
        "3"  "Buttons" \
        "4"  "Backup & Restore" \
        3>&1 1>&2 2>&3 )
          case "$selection" in
            1) recoilmain ;;
            2) cameramain ;;
            3) buttonmain ;;
            4) backupmain ;;
            *) return ;;
          esac
  done
   if  $manualstart=true ; then
    dialog --infobox "\nRestart your guns for any changes to take effect\n" 5 56 3>&1 1>&2 2>&3
    sleep 4
  fi
}



##############################
############  MAIN  #########
############################


function gunsexist() {

	lightgun_files=()
	pedal_files=()
	local device_file

	for device_file in /dev/ttyACM*; do
		udev_info=$(udevadm info --query=all --name="$device_file")
		if [[ $udev_info =~ "SindenLightgun" ]]; then
			lightgun_files+=("$device_file")
		fi
	done
	
	for device_file in /dev/input/event*; do
		udev_info=$(udevadm info --query=all --name="$device_file")
		if [[ $udev_info =~ "Sinden_Pedal" ]]; then
			pedal_files+=("$device_file")
		fi
	done
}


function run_pedaltest() {

	local title="Sinden Pedal Test"
	local PEDAL_BTN=()
	local device_file=${pedal_files[$1]}
	
	devNum=$((10#${lightgun_files[$i]##*[!0-9]} + 1)) 
			
	dialog --title "$title" --backtitle "$backtitle" --infobox \
	"\n   Press the pedal\n\n(You have 10 seconds)" 7 25 3>&1 1>&2 2>&3
	timeout 10 evtest --grab "$device_file" | grep -m 1 "KEY),\|BTN)," | awk -F'[()]' '{print $(NF-1)}' > "/tmp/evtest_output" && pkill evtest &
	local EVTEST_PID=$!
	wait $EVTEST_PID
	if [ -s /tmp/evtest_output ]; then
		PEDAL_BTN=$(cat /tmp/evtest_output)
		dialog --title "$title" --backtitle "$backtitle" --infobox "\n  Pedal is sending\n\n       "$PEDAL_BTN 7 25 3>&1 1>&2 2>&3
	else
		dialog --title "$title" --backtitle "$backtitle" --infobox "\n\nNo pedal button detected" 7 28 3>&1 1>&2 2>&3
	fi
  sleep 3
}


function pedaltest_menu(){
	local title
	local selection
	local menu_items

	if [ -z "${pedal_files[0]}" ]; then
		dialog --title "$title" --backtitle "$backtitle" --infobox "\nNo Sinden pedals connected" 5 30 3>&1 1>&2 2>&3
		sleep 3
	else
		while :; do
			gunsexist
			menu_items=()
			if [ -n "${pedal_files[0]}" ]; then menu_items+=("1" "Pedal 1"); fi
			if [ -n "${pedal_files[1]}" ]; then menu_items+=("2" "Pedal 2"); fi
			if [ -n "${pedal_files[2]}" ]; then menu_items+=("3" "Pedal 3"); fi
			if [ -n "${pedal_files[3]}" ]; then menu_items+=("4" "Pedal 4"); fi
			title="Test Sinden Pedals"
			selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
			  "\nWhich pedal do you want to test/calibrate?\n\nNote: Only connected Sinden pedals are shown here.\n\nIf you have multiple pedals sending the same key, then you should change one of them using the Windows pedal configuration software." \
			  19 50 12 "${menu_items[@]}" 3>&1 1>&2 2>&3 )
			case "$selection" in
				1) run_pedaltest "0";;
				2) run_pedaltest "1";;
				3) run_pedaltest "2";;
				4) run_pedaltest "3";;
				" ") ;;
				*) return ;;
			esac
		done
	fi
}


function savechanges() {
  local yn
  yn=$(areyousure "save these changes?")
  if [ $yn == "0" ]; then


  local duration=10
  local count=$duration+1
  local percent
  local yn
  (( ++count )) 
  ( while :; do
      cat <<-EOF      # The "-" here allows EOF later to be indented with TAB
        $percent
	EOF
      (( count-=1 ))  # This can only be indented with TAB
      percent=$((100/$duration*($duration+1-$count)))
      [ $count -eq 0 ] && break
      sleep 0.1
    done ) |
    dialog --title "Saving..." --gauge "$4" 5 30 $percent

    applychange "$utilscfg" "AutostartEnable"         $cfg_enable           
    applychange "$utilscfg" "RecoilTypeP1"            $cfg_recoiltypeP1     
    applychange "$utilscfg" "RecoilTypeP2"            $cfg_recoiltypeP2     
    applychange "$utilscfg" "RecoilTypeP3"            $cfg_recoiltypeP3     
    applychange "$utilscfg" "RecoilTypeP4"            $cfg_recoiltypeP4     
    applychange "$utilscfg" "RecoilReset"             $cfg_recoilreset
    applychange "$utilscfg" "ResetTypeP1"             $cfg_resettypeP1     
    applychange "$utilscfg" "ResetTypeP2"             $cfg_resettypeP2     
    applychange "$utilscfg" "ResetTypeP3"             $cfg_resettypeP3     
    applychange "$utilscfg" "ResetTypeP4"             $cfg_resettypeP4     
    applychange "$utilscfg" "LightgunCollectionFile" "$cfg_collectionfile"
	applychange "$utilscfg" "SetOSReload" 			 "$(echo ${cfg_osr_list[@]})"

  else
    dialog --title "SAVE" --infobox "CANCELLED" 3 13
  fi

}


function comparetypes(){
  if [ "$cfg_recoiltypeP1" = "$cfg_recoiltypeP2" ] && [ "$cfg_recoiltypeP2" = "$cfg_recoiltypeP3" ] && [ "$cfg_recoiltypeP3" = "$cfg_recoiltypeP4" ]; then
    grecoil="all "$cfg_recoiltypeP1
  else
    grecoil="individual"
  fi
}


function compareresettypes(){
  if [ "$cfg_resettypeP1" = "$cfg_resettypeP2" ] && [ "$cfg_resettypeP2" = "$cfg_resettypeP3" ] && [ "$cfg_resettypeP3" = "$cfg_resettypeP4" ]; then
    greset="all "$cfg_resettypeP1
  else
    greset="individual"
  fi
}


function set_recoil(){
  local var
  var="cfg_recoiltype"$1
  case "${!var}" in
    "silent") export "$var=single"	;;
    "single") export "$var=auto"	;;
    "auto"|*) export "$var=silent"	;;
  esac
}


function set_reset(){
  local var
  var="cfg_resettype"$1
  case "${!var}" in
    "silent") export "$var=single"	;;
    "single") export "$var=auto"	;;
    "auto"|*) export "$var=silent"	;;
  esac
}


function set_global(){
  case "$grecoil" in
    "all silent")
        cfg_recoiltypeP1="single"
        cfg_recoiltypeP2="single"
        cfg_recoiltypeP3="single"
        cfg_recoiltypeP4="single"
        ;;
    "all single")
        cfg_recoiltypeP1="auto"
        cfg_recoiltypeP2="auto"
        cfg_recoiltypeP3="auto"
        cfg_recoiltypeP4="auto"
        ;;
    "all auto"|"individual"|*)
        cfg_recoiltypeP1="silent"
        cfg_recoiltypeP2="silent"
        cfg_recoiltypeP3="silent"
        cfg_recoiltypeP4="silent"
        ;;
  esac
}


function set_reset_global(){
  case "$greset" in

    "all silent")
        cfg_resettypeP1="single"
        cfg_resettypeP2="single"
        cfg_resettypeP3="single"
        cfg_resettypeP4="single"
        ;;
    "all single")
        cfg_resettypeP1="auto"
        cfg_resettypeP2="auto"
        cfg_resettypeP3="auto"
        cfg_resettypeP4="auto"
        ;;
    "all auto"|"individual"|*)
        cfg_resettypeP1="silent"
        cfg_resettypeP2="silent"
        cfg_resettypeP3="silent"
        cfg_resettypeP4="silent"
        ;;
  esac
}


function set_collectionfile(){
  local title="Set your Lightgun Games Collection file."
  local selection
  local i=0 # define counting variable
  local j=0 # define counting variable
  local firstlist=() # define working array  local line
  firstlist+=($j "No File. (Indiscriminate Autostart)")
  while read -r line; do # process file by file
    let i=$i+1
    if [[ $line == *.cfg ]]; then
      let j=$j+1
      firstlist+=($j "$line"); fi
  done < <( ls -1 "$collectiondir" )
  selection=$(dialog --title "$title" --ok-label " Select " --cancel-label " None " --menu "Select your Lightgun Games collection file from the list of available collections." 20 70 10 "${firstlist[@]}" 3>&2 2>&1 1>&3)
  if [ ! $selection = "0" ]; then
    cfg_collectionfile="${firstlist[((($selection+1)*2)-1)]}"
    dialog --title "$title" --msgbox "\nYou have selected \"${firstlist[((($selection+1)*2)-1)]}\\n\n(Remember to save before you exit)" 10 70
  else
    dialog --title "$title" --msgbox "\n           No collection was selected\nAutostart will be enabled for all types of games\n\n       (Remember to save before you exit)" 10 52
    cfg_collectionfile="NONE"
  fi
}


function manual_start() {

  if [ $cfg_recoiltypeP1 = "off" ] && [ $cfg_recoiltypeP2 = "off" ] && [ $cfg_recoiltypeP3 = "off" ] && [ $cfg_recoiltypeP4 = "off" ]; then
    dialog --title "MANUAL START" --infobox "\n Unable to start lightgun process \nas no lightguns have been selected\n" 6 38
  else
    cfg_enable="0"
    applychange "$utilscfg" "AutostartEnable" $cfg_enable
    stopguns
    autostart
    manualstart=true
    dialog --title "MANUAL START" --infobox "\nPersistent lightgun process started\n       Autostart deactivated       \n" 6 39
  fi
  sleep 4
}


function manual_stop() {

  stopguns
  manualstart=false
  dialog --title "MANUAL STOP" --infobox "\nAll running lightgun processes killed\n" 5 41
  sleep 4

}


function run_test(){
#  clear
  local devNum
  stopguns
  manualstart=false
  var="cfg_P"$1"_norm"
  cd "${!var%/*}"
  mono "${!var%.config}" sdl 30
  sleep 3
}


function test_menu(){
	local title
	local selection
	local menu_items

	if [ -z "${lightgun_files[0]}" ]; then
		dialog --title "$title" --backtitle "$backtitle" --infobox "\nNo Sinden Lightguns connected" 5 33 3>&1 1>&2 2>&3
		sleep 3
	else
		while :; do
			gunsexist
			menu_items=()
			if [ -n "${lightgun_files[0]}" ]; then menu_items+=("1" "Player 1"); fi
			if [ -n "${lightgun_files[1]}" ]; then menu_items+=("2" "Player 2"); fi
			if [ -n "${lightgun_files[2]}" ]; then menu_items+=("3" "Player 3"); fi
			if [ -n "${lightgun_files[3]}" ]; then menu_items+=("4" "Player 4"); fi
			title="Sinden Test and Calibration"
			selection=$(dialog --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
			"\nWhich gun do you want to test/calibrate?\n\nNote: Running a test will stop any manually started running Lightgun processes" \
			16 50 12 "${menu_items[@]}" 3>&1 1>&2 2>&3 )
			case "$selection" in
				1) run_test "1";;
				2) run_test "2";;
				3) run_test "3";;
				4) run_test "4";;
				" ") ;;
				*) return ;;
			esac
		done
	fi

}

function set_osr_usage(){

	local title="Setting Offscreen Reload"
	local menu_items=()
	local selected_items=()
	local osr_item
	local status
	local index
	local item
	local emu_list=($(find "/opt/retropie/configs/" -maxdepth 1 -type d ! -name "all" -exec test -e {}/emulators.cfg \; -exec grep -hoP '^[^=]+' {}/emulators.cfg \; | grep -v "default" | sort -u))


	for ((i=0; i<${#emu_list[@]}; i++)); do
		status="off"
		for osr_item in "${cfg_osr_list[@]}"; do
			if [[ "${emu_list[i]}" == "$osr_item" ]]; then
				status="on"
				break
			fi
		done
		menu_items+="$((i+1)) ${emu_list[i]} $status "
	done

	local dialog_result=$(dialog --separate-output --title "$title" --backtitle "$backtitle" --checklist "\nChoose the emulators for which the Offscreen Reload setting in the Sinden configs should be applied:" 23 70 12 ${menu_items[@]} 3>&1 1>&2 2>&3 )

	if [ $? -eq 0 ]; then
		cfg_osr_list=()
		for item in $dialog_result; do selected_items+=("$item"); done
		
		for item in "${selected_items[@]}"; do
			index=$((item-1))
			cfg_osr_list+=("${emu_list[index]}")
		done
	fi
}

#########################
#  Options
#########################


function moremenu(){
  local title
  local selection
  local menu_items
  
  while :; do
    compareresettypes
	menu_items=()
    menu_items+=("R"  "Reset Recoil on Each Boot : $(onoffread $cfg_recoilreset)")
    menu_items+=(" "  "                                      ")
    menu_items+=("1"  "Reset Type for Player 1   : $cfg_resettypeP1")
    menu_items+=("2"  "Reset Type for Player 2   : $cfg_resettypeP2")
    menu_items+=("3"  "Reset Type for Player 3   : $cfg_resettypeP3")
    menu_items+=("4"  "Reset Type for Player 4   : $cfg_resettypeP4")
    menu_items+=("G"  "Set Global Reset Type     : $greset") 
    menu_items+=(" "  "                                      ")
    menu_items+=("C"  "Set Lightgun Collection File")
    menu_items+=("O"  "Set O/S Reload Usage")
    menu_items+=(" "  "                                      ")
    menu_items+=("T"  "Test and Calibrate Lightguns")
	menu_items+=("P"  "Test Sinden Pedals")
	menu_items+=(" "  "                                      ")
    menu_items+=("E"  "Lightgun Config Editor")

    title="More Sinden Autostart Options"
    selection=$(dialog --help-button --cancel-label " Back " --title "$title" --backtitle "$backtitle" --menu \
        "\nApply your settings here" \ 23 70 12 "${menu_items[@]}" 3>&1 1>&2 2>&3 )
          case "$selection" in
            R) cfg_recoilreset=$(onoffwrite $cfg_recoilreset)  ;;
            1) set_reset "P1";;
            2) set_reset "P2";;
            3) set_reset "P3";;
            4) set_reset "P4";;
            G) set_reset_global ;;
            C) set_collectionfile ;;
			O) set_osr_usage ;;
			T) test_menu ;;
			P) pedaltest_menu ;;
			E) cfgeditmenu ;;
			" ") ;;
            *)  if [ $? -eq 2 ]; then showhelp; else return; fi;;
          esac
  done
}


function mainmenu(){
  local title
  local selection
  local menu_items
  
  while :; do
    comparetypes
    gunsexist
	menu_items=()
    menu_items+=("A"  "Autostart Lightguns       : $(onoffread $cfg_enable)")
    menu_items+=(" "  "                                      ")
    menu_items+=("G"  "Set States Globally       : $grecoil") 
    if [ -n "${lightgun_files[0]}" ]; then menu_items+=("1"  "Player 1                  : $cfg_recoiltypeP1"); fi
    if [ -n "${lightgun_files[1]}" ]; then menu_items+=("2"  "Player 2                  : $cfg_recoiltypeP2"); fi
    if [ -n "${lightgun_files[2]}" ]; then menu_items+=("3"  "Player 3                  : $cfg_recoiltypeP3"); fi
    if [ -n "${lightgun_files[3]}" ]; then menu_items+=("4"  "Player 4                  : $cfg_recoiltypeP4"); fi
    menu_items+=(" "  "                                      ")
    menu_items+=("S"  "Save Changes")
    menu_items+=("X"  "Reset Unsaved Changes")
    menu_items+=(" "  "                                      ")
    menu_items+=("M"  "Manually Start Lightguns - until stopped")
    menu_items+=("K"  "Kill Running Lightgun Processes")
    menu_items+=(" "  "                                      ")
    menu_items+=("Z"  "More Options...")

    title="Sinden Autostart Options"
    selection=$(dialog --help-button --cancel-label " Exit " --title "$title" --backtitle "$backtitle" --menu \
        "\nApply your settings here" \ 23 70 12 "${menu_items[@]}" 3>&1 1>&2 2>&3 )
          case "$selection" in
            A) cfg_enable=$(onoffwrite $cfg_enable)  ;;
            G) set_global ;;
            1) set_recoil "P1";;
            2) set_recoil "P2";;
            3) set_recoil "P3";;
            4) set_recoil "P4";;
            S) savechanges ;;
            X) prep ;;
            M) manual_start ;;
            K) manual_stop ;;
			Z) moremenu ;;
			" ") ;;
            *)  if [ $? -eq 2 ]; then showhelp; else return; fi;;
          esac
  done

  cfg_enable=$(grabber "<AutostartEnable>" "$utilscfg")
  if [ $cfg_enable = "1" ]; then
    stopguns
  fi
}


function showhelp() {
  local helptxt
  local title
  helptxt="/home/$USERNAME/Lightgun/utils/help.txt"
  title="Sinden Lightgun Autostart Options Help"
  dialog --scrollbar --no-collapse --title "$title" --backtitle "$backtitle" --msgbox "$(head -c 5K $helptxt)" 35 70
  sleep 3
  echo $?
}



#########################
#  Autostop
#########################


function stopguns(){
    pkill -9 -f "mono"
    rm /tmp/LightgunMono* -f
	disable_os_reload_buttons
}



#########################
#  Recoil Reset
#########################


function recoilreset(){
  if [ $cfg_recoilreset = 1 ]; then
    echo "reset the recoil"
    applychange "$utilscfg" "RecoilTypeP1" $cfg_resettypeP1
    applychange "$utilscfg" "RecoilTypeP2" $cfg_resettypeP2
    applychange "$utilscfg" "RecoilTypeP3" $cfg_resettypeP3
    applychange "$utilscfg" "RecoilTypeP4" $cfg_resettypeP4
  else
    echo "don't reset"
  fi

}



#########################
#  Uninstall
#########################


function linedelete(){
  sed -i "/$1/d" $2
}


function uninstall() {
  local yn
  echo "This command will uninstall Sinden Autostart."
  echo " : Proceeding with uninstall!"
  
  applychange "$utilscfg" "AutostartEnable"        "0"
  echo "...Autostart disabled in widgeutils.cfg..."
  linedelete "sindenautostart.sh" "/opt/retropie/configs/all/autostart.sh"
  linedelete "sindenautostart.sh" "/opt/retropie/configs/all/runcommand-onlaunch.sh"
  linedelete "sindenautostart.sh" "/opt/retropie/configs/all/runcommand-onend.sh"
  echo "...Removed references to sindenautostart from EmulationStation files..."
  /bin/rm -f "/home/$USERNAME/Lightgun/utils/sindenautostart.sh"
  echo "...Deleted sindenautostart.sh..."
  bin/rm -f "/home/$USERNAME/RetroPie/roms/sinden/Sinden Lightgun Autostart Options.sh"
  bin/rm -f "/home/$USERNAME/RetroPie/roms/ports/Sinden Lightgun Autostart Options.sh"
  echo "...Deleted Options Menu from EmulationStation..."
  echo "Uninstall complete."
}



#########################
#  Autostart
#########################


function enable_os_reload_buttons() {		## ## -- Required for Supermodel o/s reloading. Can be deleted if o/s reload toggle is implemented in Sinden driver release (see Autostart section below)
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P1_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P2_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P3_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P4_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P1_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P2_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P3_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P4_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P1_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P2_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P3_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"1\"/" $cfg_P4_auto
	
}


function disable_os_reload_buttons() {		## ## -- Required for Supermodel o/s reloading. Can be deleted if o/s reload toggle is implemented in Sinden driver release (see Autostart section below)
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P1_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P2_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P3_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P4_norm
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P1_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P2_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P3_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P4_reco
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P1_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P2_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P3_auto
	sed -i -e "/.*\"OffscreenReload\"/s/value=\".*\"/value=\"0\"/" $cfg_P4_auto
	
}


function autostart(){  
  local rc_emu="$2"
  local rc_rom="$3"
  local rc_collection="$collectiondir/$cfg_collectionfile"
  local player; local devNum; local typeVar
  local i; local j
  local item

  if  fgrep -q "$rc_rom" "$rc_collection" || [ $cfg_collectionfile = "NONE" ]; then
  
	
	 for item in "${cfg_osr_list[@]}"; do
        if [[ "$rc_emu" == "$item" ]]; then
            echo "Emulator $rc_emu detected. Enabling offscreen reloading..."
			sleep 3
            enable_os_reload_buttons
			break
        fi
    done
	
	gunsexist
	 
	for ((i=0; i<4; i++)); do
		j=$((i + 1))  # Increment the value of i to get j
		if [ -n "${lightgun_files[$i]}" ]; then
			devNum=$((10#${lightgun_files[$i]##*[!0-9]} + 1)) 
			player="cfg_P"$j"_"

			typeVar="cfg_recoiltypeP${j}"
			case "${!typeVar}" in
				single) player="${player}reco" ;;
				auto)   player="${player}auto" ;;
				*)      player="${player}norm" ;;
			esac

			if [ -n "${lightgun_files[$i]}" ]; then
				cd "${!player%/*}"
				mono-service "${!player%.config}"
			fi 
		fi
	done
	sleep 5

  fi
}



#############################
############  START  #######
###########################


prep

while getopts a:rxu flag
  do
    case "${flag}" in
      a) if [ $cfg_enable = "1" ]; then autostart "$2" "$3" "$4" "$5"; fi ;;
      r) recoilreset ;;
      x) if [ $cfg_enable = "1" ]; then stopguns; fi ;;
      u) uninstall ;;
      *) echo "Invalid switch option." ;;
    esac
    exit
  done


/opt/retropie/admin/joy2key/joy2key start
mainmenu
/opt/retropie/admin/joy2key/joy2key stop
clear
