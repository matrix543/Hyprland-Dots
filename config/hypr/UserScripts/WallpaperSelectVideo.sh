#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ 
# This script for selecting Video wallpapers (SUPER V)
##This script need mpvpaper and mpv 
##if you use a video wallpaper it can glitch when you switch to a regular wallpaper with the waybar give double waybars
##you need a png of each video file for preview in rofi meny can be created with 
##ffmpeg -i video.webm video.webm.png

# WALLPAPERS PATH
wallDIR="$HOME/Video/wallpapers"

##wallDIR="$HOME/Pictures/wallpapers"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# variables
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

# Retrieve image files using null delimiter to handle spaces in filenames
mapfile -d '' VIDS < <(find "${wallDIR}" -type f \( -iname "*.mp4" -o -iname "*.webm" \) -print0)

RANDOM_VID="${VIDS[$((RANDOM % ${#VIDS[@]}))]}"
RANDOM_PIC_NAME=". random"

# Rofi command
rofi_command="rofi -i -show -dmenu -config ~/.config/rofi/config-wallpaper.rasi"

# Sorting Wallpapers
menu() {
  # Sort the PICS array
  IFS=$'\n' sorted_options=($(sort <<<"${VIDS[*]}"))
  
  # Place ". random" at the beginning with the random picture as an icon
  
  printf "%s\x00icon\x1f%s\n" "$RANDOM_PIC_NAME" "$RANDOM_VID".png
  
  for pic_path in "${sorted_options[@]}"; do
    pic_vid=$(basename "$pic_path")
    
    # Displaying .gif to indicate animated images
    if [[ ! "$pic_vid" =~ \.webm$ ]]; then
	
      printf "%s\x00icon\x1f%s\n" "$(echo "{$pic_vid%.*}" | cut -d. -f1)" "${pic_path%*.}".png
      
    else
     printf "%s\x00icon\x1f%s\n" "$(echo "${pic_vid%.*}" | cut -d. -f1)" "${pic_path%*.}".png
     ##printf "%s\n" "${pic_name%*.}"
    fi
  done
}

# Choice of wallpapers
main() {
  choice=$(menu | $rofi_command)
  
  # Trim any potential whitespace or hidden characters
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)

  # No choice case
  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  # Random choice case
  if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
	if pidof mpvpaper > /dev/null; then
	  pkill mpvpaper
	fi
	
	echo "$RANDOM_VID.png" > $HOME/.cache/swww/$focused_monitor;	
	mpvpaper -p -o "no-audio loop load-scripts=no" "*" "$RANDOM_VID";
	
    	sleep 0.5
    	"$SCRIPTSDIR/WallustSwww.sh"
    	sleep 0.2
    	"$SCRIPTSDIR/Refresh.sh"
    	exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!VIDS[@]}"; do
    filename=$(basename "${VIDS[$i]}")
    
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    if pidof mpvpaper > /dev/null; then
  	pkill mpvpaper
    fi
   
    echo "${VIDS[$pic_index]}.png" > $HOME/.cache/swww/$focused_monitor;
    mpvpaper -p -o "no-audio loop load-scripts=no" "*" "${VIDS[$pic_index]}";
    
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  sleep 1  # Allow some time for rofi to close
fi

main

sleep 0.5
"$SCRIPTSDIR/WallustSwww.sh"

sleep 0.5
"$SCRIPTSDIR/Refresh.sh"
