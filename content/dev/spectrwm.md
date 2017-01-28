Title: Spectrwm
Date: 2017-01-21 11:45
Tags: dev
Slug: spectrwm
Author: Feng Xia
Status: Draft

My favourate [desktop manage][1] which tiles windows neatly so I never
worry about cluttered view while opening and closing windows. 

[1]: https://wiki.archlinux.org/index.php/spectrwm

Here is the [config][2] file I'm using.

[2]: {attach}/downloads/spectrwm.conf

<pre class="brush:plain;">
# PLEASE READ THE MAN PAGE BEFORE EDITING THIS FILE!
# http://opensource.conformal.com/cgi-bin/man-cgi?spectrwm

# colors for focussed and unfocussed window borders
# NOTE: all colors in this file are in hex! see XQueryColor for examples
color_focus		= red
color_unfocus		= rgb:88/88/88

# bar settings
bar_enabled		= 1
bar_border_width	= 1
bar_border[1]		= rgb:00/80/80
bar_color[1]		= black
bar_font_color[1]	= rgb:a0/a0/a0
bar_font		= -*-terminus-medium-*-*-*-*-*-*-*-*-*-*-*
#bar_action		= baraction.sh
bar_action		= conky
bar_delay		= 1
bar_justify		= right
bar_at_bottom		= 0
stack_enabled		= 1
clock_enabled		= 1
clock_format		= %a %b %d %R %Z %Y
title_name_enabled	= 0
title_class_enabled	= 0
window_name_enabled	= 0
verbose_layout		= 1
focus_mode		= default
disable_border		= 1
border_width		= 1
urgent_enabled		= 1

# spawn app
program[term]		= terminator
#program[screenshot_all]	= screenshot.sh full
#program[screenshot_wind]= screenshot.sh window
#program[lock]		= xlock
#program[initscr]	= initscreen.sh
program[menu]		= dmenu_run -fn $bar_font -nb $bar_color -nf $bar_font_color -sb $bar_border -sf $bar_color
spawn_term		= terminator

# dialog box size ratio .3 >= r < 1
# dialog_ratio		= 0.6

# Split a non-Xrandr dual head setup into one region per monitor
# (non-standard driver-based multihead is not seen by spectrwm)
# region		= screen[1]:1280x1024+0+0
# region		= screen[1]:1280x1024+1280+0

# Launch applications in a workspace of choice
autorun		= ws[1]:terminator
autorun		= ws[2]:google-chrome
autorun		= ws[3]:emacs

# workspace layout
# layout		= ws[1]:4:0:0:0:vertical
# layout		= ws[2]:0:0:0:0:horizontal
# layout		= ws[3]:0:0:0:0:fullscreen

# mod key, (windows key is Mod4) (apple key on OSX is Mod2)
modkey = Mod4

# Clear key bindings and load new key bindings from the specified file.
# This allows you to load pre-defined key bindings for your keyboard layout.
# keyboard_mapping = ~/.spectrwm_us.conf

# quirks
# remove with: quirk[class:name] = NONE
# quirk[MPlayer:xv]			= FLOAT + FULLSCREEN + FOCUSPREV
quirk[OpenOffice.org 2.4:VCLSalFrame]	= FLOAT
quirk[OpenOffice.org 3.0:VCLSalFrame]	= FLOAT
quirk[OpenOffice.org 3.1:VCLSalFrame]	= FLOAT
# quirk[Firefox-bin:firefox-bin]		= TRANSSZ
# quirk[Firefox:Dialog]			= FLOAT
# quirk[Gimp:gimp]			= FLOAT + ANYWHERE
# quirk[XTerm:xterm]			= XTERM_FONTADJ
# quirk[xine:Xine Window]			= FLOAT + ANYWHERE
# quirk[Xitk:Xitk Combo]			= FLOAT + ANYWHERE
# quirk[xine:xine Panel]			= FLOAT + ANYWHERE
# quirk[Xitk:Xine Window]			= FLOAT + ANYWHERE
# quirk[xine:xine Video Fullscreen Window] = FULLSCREEN + FLOAT
# quirk[pcb:pcb]				= FLOAT

# EXAMPLE: define firefox program and bind to key
# program[firefox]	= firefox http://spectrwm.org/
# bind[firefox]		= MOD+Shift+b
</pre>

For this to work properly, also install [conky][3] and write
_.conkyrc_ file:

<pre class="brush:plain;">
out_to_x no
out_to_console yes
update_interval 1.0
total_run_times 0
use_spacer none
TEXT
Up:${uptime_short} |Temp:${acpitemp}C |Batt:${battery_short} |${addr wlan0} |RAM:$memperc% |CPU:${cpu}% | ${downspeedf wlan0}
</pre>

[3]: https://github.com/brndnmtthws/conky
