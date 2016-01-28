#! /bin/bash
# Stolen from https://gist.github.com/lfender6445/70b00c97df43827279f7
#
# This if for the mac hipchat client
# To setup, download this file to any folder and save as `hip.sh`
# change the permissions of the file so it is executable using terminal
# You can do this by running `chmod u+x ./hip.sh`
# Now you can run `./hip.sh`

echo 'Hipchat hooray...ho... - Press CTRL+C to stop'
while :
do
osascript <<EOF
tell application "Hipchat" to activate

do shell script "
/usr/bin/python <<END

import sys
import time
from Quartz.CoreGraphics import *

def mouseEvent(type, posx, posy):
  theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)
  CGEventPost(kCGHIDEventTap, theEvent)

def mousemove(posx,posy):
  mouseEvent(kCGEventMouseMoved, posx,posy);

ourEvent = CGEventCreate(None);
currentpos=CGEventGetLocation(ourEvent);
mousemove(int(currentpos.x),int(currentpos.y));
END"
EOF

sleep 299
echo 'Hipchat hooray...ho...'
done
