#!/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && ( echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1 )
source "$DOTFILES_ROOT/script/lib.sh"

# Initialize sudo password save
init_sudo

###############################################################################
# User Specific                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
question " (OSX) What is your computer's name?" "$DOTFILES_OSX_COMPUTER_NAME" "Setting computer name to $DOTFILES_OSX_COMPUTER_NAME..."
computer_name=$answer
if [ $computer_name ]; then
	sudo scutil --set ComputerName $computer_name
	sudo scutil --set HostName $computer_name
	sudo scutil --set LocalHostName $computer_name
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $computer_name
fi

# Locale settings
if confirm ' (OSX) Use US locale information?' "$DOTFILES_OSX_LOCALE_US" "Setting locale to US..."; then
	defaults write NSGlobalDomain AppleLanguages -array "en"
	defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
	defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
	defaults write NSGlobalDomain AppleMetricUnits -bool false
	defaults write -g AppleTextBreakLocale en_US_POSIX
fi

# Set the timezone; see `systemsetup -listtimezones` for other values
if confirm ' (OSX) Use Eastern US timezone?' "$DOTFILES_OSX_TIMEZONE_EST" "Setting timezone to Eastern US"...; then
	sudo systemsetup -settimezone "America/New_York" > /dev/null
fi

# 12/24-Hour Time (true)
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true

###############################################################################
# Power Management                                                            #
###############################################################################

# Sleep on Idle (# minutes or Off/Never)
sudo systemsetup -setcomputersleep 180 > /dev/null # 3 hours

# How long to sleep before powering down compeltely  (3600 seconds)
sudo pmset -a standbydelay 28800 # 8 hours

# Hibernation (0 = disable, *3 = safe sleep, 25 = no sleep, hibernate only)
sudo pmset -a hibernatemode 25

# Remove the sleep image file to save disk space
#sudo rm /Private/var/vm/sleepimage
# Create a zero-byte file instead…
#sudo touch /Private/var/vm/sleepimage
# …and make sure it can’t be rewritten
#sudo chflags uchg /Private/var/vm/sleepimage

# Automatic termination of inactive apps (false)
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false

###############################################################################
# Restarting                                                                  #
###############################################################################

# Resume: Keep windows checkbox default
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Crash reporter (*crashreport or none)
defaults write com.apple.CrashReporter DialogType none

###############################################################################
# Security                                                                    #
###############################################################################

# Enable Firewall. Possible values:
# 0 = off
# 1 = on for specific services
# 2 = on for essential services
#sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
# Enable Stealth mode.
#sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1
# Enable Firewall logging.
#sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -int 1

# Reload Firewall
#launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist
#sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

# IR remote control
#sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

# Bluetooth
#sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
#sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
#sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist

###############################################################################
# Window UI                                                                   #
###############################################################################

# Menu bar: Icons (Displays, Time Machine, Bluetooth, Volume)
for domain in "$HOME/Library/Preferences/ByHost/com.apple.systemuiserver.*"; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
		"/System/Library/CoreServices/Menu Extras/Battery.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

# Menu bar: Transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
 
# Additional Transparency
defaults write com.apple.universalaccess reduceTransparency -bool false

# Disable Notification Center and remove the menu bar icon
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Notification display time (5 seconds)
defaults write com.apple.notificationcenterui bannerTime 3

# Scrollbars: WhenScrolling, Automatic or Always
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001 #?

# Opening and closing window animations (true)
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Double-click a window's title bar to minimize
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

###############################################################################
# Desktop                                                                     #
###############################################################################

# Desktop: Icons
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show item info below icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" "$HOME/Library/Preferences/com.apple.finder.plist"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" "$HOME/Library/Preferences/com.apple.finder.plist"

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" "$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" "$HOME/Library/Preferences/com.apple.finder.plist"

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf "$HOME/Library/Application Support/Dock/desktoppicture.db"
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
# Saving/Printing                                                             #
###############################################################################

# Save panel expansion (false, false)
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to to iCloud (true)
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false #?

# Show an iCloud window when opening TextEdit or Preview
# if syncing documents and data is enabled (true)
defaults write -g NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

# Print Panel expansion (false, false)
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete (false)
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

###############################################################################
# Miscellaneous UI                                                            #
###############################################################################

# Highlight color (RGB)
defaults write NSGlobalDomain AppleHighlightColor -string '0.847059 0.847059 0.862745' # Graphite

# Help Viewer to non-floating mode (false)
defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Spring loading directories (dragging onto folder opens it)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Spring loading directory delay
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Fix for the ancient UTF-8 bug in QuickLook (s)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > "$HOME/.CFUserTextEncoding"

# Alert sound
defaults write com.apple.systemsound 'com.apple.sound.beep.sound' -string '/System/Library/Sounds/Pop.aiff'

# User interface sound effects
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -bool true

# Remove "About Downloads.pdf" from ~/Downloads
rm -rf "$HOME/Downloads/About\ Downloads.lpdf"

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Add default keybindings dictionary for Home/End & Page Up/Down keys
cp -f "$DOTFILES_ROOT/init/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings"

# Keyboard press and hold (*true = hold for diacritic, false = repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard repeat rate (value * 15ms)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Adjust keyboard brightness in low light
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool true
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim Time" -int 300

# Auto-correct (true)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Smart quotes (true)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Smart dashes (true)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Caret blinking (Disable using extreme values)
#defaults write -g NSTextInsertionPointBlinkPeriodOff -float 0
#defaults write -g NSTextInsertionPointBlinkPeriodOn -float 999999999999

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Enable “natural” (iOS-style) scrolling (true)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Tap to click (user and login)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Right click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Three finger tap (Look up)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0

# Three finger drag (Move)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

# Zoom in or out
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true

# Smart zoom, double-tap with two fingers
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool false

# Rotate
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

# Notification Center (2 finger swipe from right edge)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# Swipe between pages with two fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false

# Swipe between full-screen apps
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2

# Three/four finger swipe up/down (Mission Control/App Expose)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2

# Four/five finger pinch (Launchpad)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2

# Swipe between apps with four fingers
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2

# General gesture support
defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showDesktopGestureEnabled -bool true
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Smooth scrolling (true)
#defaults write -g NSScrollAnimationEnabled -bool false

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

###############################################################################
# Miscellaneous Hardware                                                      #
###############################################################################

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Sudden motion sensor (0 to disable)
sudo pmset -a sms 0

###############################################################################
# Screen                                                                      #
###############################################################################

# Cmd-Opt-Ctrl-T hotkey to toggle Dark Mode
sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

# Password after screensaver/sleep (false, 5)
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screenshot location
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Screenshots format (BMP, GIF, JPG, PDF, *PNG, TIFF)
defaults write com.apple.screencapture type -string "png"

# Screenshot shadows (false)
defaults write com.apple.screencapture disable-shadow -bool true

# Screen Saver: Flurry
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "Flurry" path -string "/System/Library/Screen Savers/Flurry.saver" type -int 0

# Automatically adjust brightness
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool true

# Subpixel font rendering on non-Apple LCDs (1 = Light, 2 = Medium, 3 = Strong, 4 = None)
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Appearance ##################################################################

# View mode (Nlsv = List, *icnv = Icon, clmv = Column, Flwv = Flow)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Default location for new Finder windows
# Computer 		PfCm		None
# Volume 		PfVo		file:///
# Home 			PfHm		file://${HOME}/
# Desktop 		PfDe		file://${HOME}/Desktop/
# Documents 	PfDo 		file://${HOME}/Documents/
# *All My Files PfAf		file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch
# Other path 	PfLo 		file:///full/path/here/
defaults write com.apple.finder NewWindowTarget -string "Home"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Display full POSIX path as window title (false)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show status bar (false)
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar (false)
defaults write com.apple.finder ShowPathbar -bool true

# Show hidden files (see show/hide aliases - false)
defaults write com.apple.finder AppleShowAllFiles -bool false

# Show the ~/Library folder
chflags nohidden "$HOME/Library"

# Show filename extensions (false)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Sidebar Icon Size (1 = Smaller, *2 = Medium, 3 = Larger)
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Window animations and Get Info animations (false)
defaults write com.apple.finder DisableAllAnimations -bool false

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/check.icns
#[ -e "$file" ] && mv -f "$file" "$file.bak"
#unset file

# Behavior ####################################################################

# Warn when changing file extension (true)
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Search Scope (*???? = This Mac, SCcf = Current Folder, ???? = Shared)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons (false)
defaults write com.apple.finder QuitMenuItem -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true #?

# Quick look window opening and closing animation duration
#defaults write -g QLPanelAnimationDuration -float 0

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
 General -bool true \
 OpenWith -bool true \
 Privileges -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
if confirm ' (OSX) Would you like to remove all icons from the Dock?' "$DOTFILES_OSX_DOCK_CLEAR" "Clearing icons from the Dock..."; then
	defaults write com.apple.dock persistent-apps -array
fi

# Autohide Dock (false)
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.Dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Icon size (64 pixels)
defaults write com.apple.dock tilesize -int 36

# Open application indicators (true)
defaults write com.apple.dock show-process-indicators -bool true

# Add a spacer to the left side of the Dock (where the applications are)
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Bouncing icon when launching an app
defaults write com.apple.dock launchanim -bool true

# Minimize/maximize window effect (*genie, scale, suck)
defaults write com.apple.dock mineffect -string "genie"

# Minimize windows into their application’s icon (false)
defaults write com.apple.dock minimize-to-application -bool false

# Highlight hover the grid view of a stack (true)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Spring load all the things!
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Warn before emptying trash (true)
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely (false)
defaults write com.apple.finder EmptyTrashSecurely -bool false

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true #?

###############################################################################
# Mission Control / Launchpad / Dashboard                                     #
###############################################################################

# Mission Control: Animation speed
defaults write com.apple.dock expose-animation-duration -float 0.1

# Mission Control: Group windows (true)
defaults write com.apple.dock expose-group-by-app -bool true

# Mission Control: Rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false #?

# Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -maxdepth 1 -name "*-*.db" -delete #?

# Add iOS Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true #?

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true #?

###############################################################################
# Hot Corners                                                                 #
###############################################################################

# Hot corners
# Possible values:
# 0: no-op
# 2: Mission Control
# 3: Show application windows
# 4: Desktop
# 5: Start screen saver
# 6: Disable screen saver
# 7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner
#defaults write com.apple.dock wvous-tr-corner -int 4
#defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner
#defaults write com.apple.dock wvous-bl-corner -int 5
#defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner
#defaults write com.apple.dock wvous-br-corner -int 10
#defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Spotlight #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Change indexing order and disable some file types
defaults write com.apple.spotlight orderedItems -array \
 '{"enabled" = 1;"name" = "APPLICATIONS";}' \
 '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
 '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
 '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
 '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
 '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
 '{"enabled" = 1;"name" = "DOCUMENTS";}' \
 '{"enabled" = 1;"name" = "DIRECTORIES";}' \
 '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
 '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
 '{"enabled" = 1;"name" = "PDF";}' \
 '{"enabled" = 1;"name" = "MESSAGES";}' \
 '{"enabled" = 1;"name" = "CONTACT";}' \
 '{"enabled" = 1;"name" = "EVENT_TODO";}' \
 '{"enabled" = 1;"name" = "IMAGES";}' \
 '{"enabled" = 1;"name" = "BOOKMARKS";}' \
 '{"enabled" = 1;"name" = "MUSIC";}' \
 '{"enabled" = 1;"name" = "MOVIES";}' \
 '{"enabled" = 1;"name" = "FONTS";}' \
 '{"enabled" = 1;"name" = "SOURCE";}' \
 '{"enabled" = 1;"name" = "MENU_OTHER";}' \
 '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Mac App Store / App Installation                                            #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true #?

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Check for software updates (7 days)
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1 # 1 day

# Disable GateKeeper
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor                                                            #
###############################################################################

#  Show the main window when launching
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true #?

# Visualize CPU usage in the dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Update Frequency (Very Often = 1, Often - 2 sec, *Normally - 5 sec)
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" #?
defaults write com.apple.ActivityMonitor SortDirection -int 0 #?

# Add the "% CPU" column to the Disk and Network tabs
defaults write com.apple.ActivityMonitor "UserColumnsPerTab v4.0" -dict \
	'0' '( Command, CPUUsage, CPUTime, Threads, IdleWakeUps, PID, UID )' \
	'1' '( Command, anonymousMemory, Threads, Ports, PID, UID, ResidentSize )' \
	'2' '( Command, PowerScore, 12HRPower, AppSleep, graphicCard, UID )' \
	'3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID, CPUUsage )' \
	'4' '( Command, txBytes, rxBytes, txPackets, rxPackets, PID, UID, CPUUsage )'

# Sort by CPU usage in Disk and Network tabs
defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
	'0' '{ direction = 0; sort = CPUUsage; }' \
	'1' '{ direction = 0; sort = ResidentSize; }' \
	'2' '{ direction = 0; sort = 12HRPower; }' \
	'3' '{ direction = 0; sort = CPUUsage; }' \
	'4' '{ direction = 0; sort = CPUUsage; }'

# Show Data in the Disk graph (instead of IO)
defaults write com.apple.ActivityMonitor DiskGraphType -int 1

# Show Data in the Network graph (instead of packets)
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

###############################################################################
# Other Utilities                                                             #
###############################################################################

# Address Book: Address format
defaults write com.apple.AddressBook ABDefaultAddressCountryCode -string "us"

# Address Book: Display format ("First Last" = 0, "Last, First" = 1)
defaults write com.apple.AddressBook ABNameDisplay -int 0

# Address Book: Sort by
defaults write com.apple.AddressBook ABNameSortingFormat -string "sortingLastName sortingFirstName"

# Address Book: Enable the debug menu
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# TextEdit: Use plain text mode for new documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Disk Utility: Enable the debug menu
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "cfprefsd" "Contacts" "Dock" "Finder" "Mail" \
	"Safari" "SystemUIServer"; do
	killall "$app" > /dev/null 2>&1
done
