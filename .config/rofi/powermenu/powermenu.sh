#!/usr/bin/env bash
#   ══╗   ╲╱  ╔══   ══╗ ║     ╸ ║  ╱║
#   ══╣   ╱╲  ║ ═╗  ══╣ ║     ║ ║ ╱ ║
#   ══╝       ╚══╝  ══╝ ╚═══  ║ ║╱  ║
#
#   Modification by     -    3xg3lin
#   Source              -    https://github.com/3xg3lin/dotfiles
#

dir="$HOME/.config/rofi/powermenu/powerconfig"

# CMDs
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
hibernate=''
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " Uptime: $uptime" \
		-mesg "Goodbye $USER" \
		-theme ${dir}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;height: 250px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "textbox-prompt-colon", "listview" ];}' \
		-theme-str 'listview {columns: 1; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Are you Sure?' \
		-mesg 'Confirmation' \
		-theme ${dir}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			bspc quit
	fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
		betterlockscreen -l
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
