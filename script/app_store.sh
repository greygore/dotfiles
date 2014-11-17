#!/usr/bin/env bash

# Mac App Store links
# App IDs pulled from https://linkmaker.itunes.apple.com/us/
if [ ! -e '/Applications/Trillian.app' ]; then
	pause 'Opening Mac App Store for Trillian. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id412056820?mt=12
fi
if [ ! -e '/Applications/Wunderlist.app' ]; then
	pause 'Opening Mac App Store for Wunderlist. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id410628904?mt=12
fi
if [ ! -e '/Applications/Leaf.app' ]; then
	pause 'Opening Mac App Store for Leaf. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id576338668?mt=12
fi
if [ ! -e '/Applications/Pocket.app' ]; then
	pause 'Opening Mac App Store for Pocket. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id568494494?mt=12
fi
if [ ! -e '/Applications/Characters.app' ]; then
	pause 'Opening Mac App Store for Characters. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id536511979?mt=12
fi
if [ ! -e '/Applications/Kindle.app' ]; then
	pause 'Opening Mac App Store for Kindle. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id405399194?mt=12
fi
if [ ! -e "/Applications/LifeSpan Active +.app" ]; then
	pause 'Opening Mac App Store for Lifespan Active +. Press any key to continue.'
	open macappstore://itunes.apple.com/app/id804738629?mt=12
fi
