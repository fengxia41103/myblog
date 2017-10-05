Title: Sensitive touchpad
Date: 2017-10-04 21:15
Tags: dev
Slug: sensitive touchpad
Author: Feng Xia

The symptom is that typing jumps all over the place.

1. `xinput list` to get a list (uses the `ssh -X` if on remote
   machine):
   <pre class="brush:plain;">
   (dev) fengxia@fengxia-lenovo:~/workspace/wss$ xinput list
   ⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
   ⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
   ⎜   ↳ SynPS/2 Synaptics TouchPad              	id=11	[slave  pointer  (2)]
   ⎜   ↳ TPPS/2 IBM TrackPoint                   	id=13	[slave  pointer  (2)]
   ⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
       ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
       ↳ Power Button                            	id=6	[slave  keyboard (3)]
       ↳ Video Bus                               	id=7	[slave  keyboard (3)]
       ↳ Sleep Button                            	id=8	[slave  keyboard (3)]
       ↳ Integrated Camera                       	id=9	[slave  keyboard (3)]
       ↳ AT Translated Set 2 keyboard            	id=10	[slave  keyboard (3)]
       ↳ ThinkPad Extra Buttons                  	id=12	[slave  keyboard (3)]
   </pre>
   
2. To disable a device, eg. _TPPS/2 IBM TrackPoint_ (index 13):
   `xinput disable 13`.
3. To view device details: `xinput list-props 11`:
   <pre class="brush:plain;">
   (dev) fengxia@fengxia-lenovo:~/workspace/wss$ xinput list-props 11
   Device 'SynPS/2 Synaptics TouchPad':
       Device Enabled (139):	1
       Coordinate Transformation Matrix (141):	1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
       Device Accel Profile (263):	1
       Device Accel Constant Deceleration (264):	2.500000
       Device Accel Adaptive Deceleration (265):	1.000000
       Device Accel Velocity Scaling (266):	12.500000
       Synaptics Edges (267):	1571, 5369, 1353, 4499
       Synaptics Finger (268):	55, 60, 0
       Synaptics Tap Time (269):	180
       Synaptics Tap Move (270):	252
       Synaptics Tap Durations (271):	180, 100, 100
       Synaptics ClickPad (272):	1
       Synaptics Middle Button Timeout (273):	0
       Synaptics Two-Finger Pressure (274):	282
       Synaptics Two-Finger Width (275):	7
       Synaptics Scrolling Distance (276):	114, 114
       Synaptics Edge Scrolling (277):	1, 0, 0
       Synaptics Two-Finger Scrolling (278):	1, 0
       Synaptics Move Speed (279):	1.000000, 1.750000, 0.034886, 0.000000
       Synaptics Off (280):	0
       Synaptics Locked Drags (281):	0
       Synaptics Locked Drags Timeout (282):	5000
       Synaptics Tap Action (283):	2, 3, 0, 0, 1, 3, 0
       Synaptics Click Action (284):	1, 3, 0
       Synaptics Circular Scrolling (285):	0
       Synaptics Circular Scrolling Distance (286):	0.100000
       Synaptics Circular Scrolling Trigger (287):	0
       Synaptics Circular Pad (288):	0
       Synaptics Palm Detection (289):	0
       Synaptics Palm Dimensions (290):	10, 200
       Synaptics Coasting Speed (291):	20.000000, 50.000000
       Synaptics Pressure Motion (292):	30, 160
       Synaptics Pressure Motion Factor (293):	1.000000, 1.000000
       Synaptics Resolution Detect (294):	1
       Synaptics Grab Event Device (295):	0
       Synaptics Gestures (296):	1
       Synaptics Capabilities (297):	1, 0, 0, 1, 1, 1, 1
       Synaptics Pad Resolution (298):	68, 46
       Synaptics Area (299):	0, 0, 0, 0
       Synaptics Soft Button Areas (300):	3470, 0, 4095, 0, 0, 0, 0, 0
       Synaptics Noise Cancellation (301):	28, 28
       Device Product ID (257):	2, 7
       Device Node (258):	"/dev/input/event5"
   </pre>
3. To tweak touchpad sensitivity: look for line `Synaptics Finger
   (268):	55, 60, 0`:
   
    - 55 = FingerLow (as you remove your finger from the touchpad)
    - 60 = FingerHigh (pressure required to use the touchpad).
   
    **The higher the number, the less sensitive it
    becomes**. On X1 4th gen, setting to `60 65` makes it feels
    solid, `65 70` is hardly responsive. 
    The old values of `25 30` was too sensitive.
    
    <pre class="brush:plain;">
    xinput set-prop 11 268 60 65 0
    </pre>
    
4. Search for `synaptics.conf`. On X1 4th gen, it's located at
   `/usr/share/X11/xorg.conf.d/50-synaptics.conf`. Add two lines to
   it (alternatively, add the `set-prop` line from step 4 
   to your `.bashrc` works too):
   <pre class="brush:plain;">
   Section "InputClass"
           Identifier "touchpad catchall"
           Driver "synaptics"
           MatchIsTouchpad "on"
           Option "FingerLow" "60" # <--
           Option "FingerHigh" "65" # <--
   </pre>

Reboot, and verify using `xinput list-props [index]` that new values
are in use. You should be good now.
