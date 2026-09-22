dwm &
pipewire &
xwinwrap -g 2560x1440+0+0 -fdt -ni -nf -b -st -sp -ov -- st -w WID -g 365x100 -e asciiquarium &
xwinwrap -g 2560x1440+0+1440 -fdt -ni -nf -b -st -sp -ov -- st -w WID -g 365x100 -e cmatrix -abco &
udiskie &
xrandr --output HDMI-1 --primary --rate 150 --above eDP-1 &
slstatus

