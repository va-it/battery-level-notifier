#!/bin/bash

LOW=50
HIGH=80
NOT_CHARGING="0"
CHARGING="1"
ICON_LOW="/usr/share/icons/ubuntu-mono-dark/status/24/unity-battery-040.svg"
ICON_HIGH="/usr/share/icons/ubuntu-mono-dark/status/24/unity-battery-080-charging.svg"

export DISPLAY=:0


while true
    do 
	POWERSUPPLY="/sys/class/power_supply/AC/online" # could be different
	STATUS=$(cat $POWERSUPPLY)
	RETRIEVE_BATTERY_INFO=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage")
	BATTERY_LEVEL=$(echo $RETRIEVE_BATTERY_INFO | grep -P -o '[0-9]+(?=%)')	

	if [[ $BATTERY_LEVEL -le $LOW && $STATUS == $NOT_CHARGING ]]
		then
		paplay /usr/share/sounds/Yaru/stereo/battery-low.oga
		/usr/bin/notify-send -u critical -i "$ICON_LOW" -t 3000 "Battery low" "Battery level is ${BATTERY_LEVEL}%!"
	fi

	if [[ $BATTERY_LEVEL -ge $HIGH && $STATUS == $CHARGING ]]
		then
		paplay /usr/share/sounds/Yaru/stereo/dialog-warning.oga
		/usr/bin/notify-send -u critical -i "$ICON_HIGH" -t 3000 "Battery high" "Battery level is ${BATTERY_LEVEL}%!"
	fi

        sleep 60
    done

exit 0
