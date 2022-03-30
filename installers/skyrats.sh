#!/bin/bash

## Check if it is into intallers/
if [[ `dirname $0` != "." ]]; then
    echo "Please, go into installers folder ;)"
    echo "(Try something like 'cd installers/')"
    exit 0
fi

## Import scripts' common tools
source ../lib/extra_tools.sh

## Source progress bar
source ../lib/progress_bar.sh

## Initialize variables
SBC_SCRIPT="false"
# Go to this file's path
MY_PATH=`whereAmIFrom`

## Parse arguments
for arg in "$@"
do
	if [[ $arg == "--sbc" ]]; then
		SBC_SCRIPT="true"
	else 
		if [[ $arg != $0 ]]; then
			echo "$arg do not recognized"
			echo "  Possible flags:"
			echo "  --sbc : version to use in single boards computers"
			exit 0;
		fi
		
    	fi
done

## Add description in .bashrc
addToBashrc "## SKYRATS setups:"

## Progress bar initial configurations
# Make sure that the progress bar is cleaned up when user presses ctrl+c
enable_trapping
# Create progress bar
setup_scroll_area

## | ----------------------- install ROS2 ---------------------- |
draw_progress_bar 0
echo -e "\n\n ... Install ROS2 \n\n"
bash "$MY_PATH/ros.sh"

## | --------------------- install gitman --------------------- |
draw_progress_bar 14
echo -e "\n\n ... Install gitman \n\n"
bash "$MY_PATH/gitman.sh"

## | ---------------- install px4 dependencies ---------------- |
if [[ SBC_SCRIPT="false" ]]; then 
    draw_progress_bar 29
    echo -e "\n\n ... Install px4 dependencies \n\n"
    bash "$MY_PATH/px4.sh" --no-gitman.sh
fi

## | ------------------- install fastRTPS --------------------- |
draw_progress_bar 43
echo -e "\n\n ... Install fastRTPS \n\n"
bash "$MY_PATH/fastRTPS.sh" --no-gitman.sh

## | ------------------ create skyrats_ws2 ---------------------- |
draw_progress_bar 57
echo -e "\n\n ... Create skyrats_ws2 \n\n"
bash "$MY_PATH/ros_ws.sh" --no-gitman.sh

## | ---------------- install qgroundcontrol ---------------- |
if [[ SBC_SCRIPT="false" ]]; then 
    draw_progress_bar 72
    echo -e "\n\n ... Install qgroundcontrol \n\n"
    bash "$MY_PATH/qgroundcontrol.sh"
fi

## | -------------- install aditional softwares -------------- |
draw_progress_bar 86
echo -e "\n\n ... Install aditional softwares \n\n"
bash "$MY_PATH/others.sh"

## End the progress bar
destroy_scroll_area
