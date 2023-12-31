#!/usr/bin/bash
PICTURE=$(ls ~/Pictures|shuf -n 1)
WHICHPIC=$(cat ~/.config/rofi/config.rasi|grep -o 'guweiz[0-9]*.jpg')
(cat ~/.cache/wal/sequences &)
wal -i ~/Pictures/$PICTURE -q
PRIMARY=$(grep -i "color1='#[0-9,A-Z,a-z]*'" ~/.cache/wal/colors.sh|grep -o "#[0-9,A-Z,a-z]*")
sed -i "323s/#[0-9,A-Z,a-z]*/$PRIMARY/" $HOME/.config/dunst/dunstrc
sed -i -e "s/%{F#[0-9,A-Z]*}/%{F$PRIMARY}/g" $HOME/.config/polybar/config.ini
polybar-msg cmd restart
picom &
sed -i "s/$WHICHPIC/$PICTURE/g" ~/.config/rofi/config.rasi ~/.config/rofi/powermenu/powerconfig.rasi
feh --bg-fill  ~/Pictures/$PICTURE
#feh --bg-fill ~/Pictures/black-screen.jpg
systemctl restart --user dunst.service &
betterlockscreen -u ~/Pictures/$PICTURE
