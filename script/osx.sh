#!/usr/bin/env bash

# ~/.osx — https://mths.be/osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
user " - (OSX) What is your computer's name?"
read -e computer_name
sudo scutil --set ComputerName $computer_name
sudo scutil --set HostName $computer_name
sudo scutil --set LocalHostName $computer_name
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $computer_name

# How long to sleep before powering down compeltely  (3600 seconds)
sudo pmset -a standbydelay 28800 # 8 hours

# Menu bar: Icons (Displays, Time Machine, Bluetooth, Volume)
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
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

# Scrollbars: WhenScrolling, Automatic or Always
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Highlight color (RGB)
defaults write NSGlobalDomain AppleHighlightColor -string '0.847059 0.847059 0.862745' # Graphite

# Finder Sidebar Icon Size (1 = Smaller, *2 = Medium, 3 = Larger)
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001 #?

# Save panel expansion (false, false)
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to to iCloud (true)
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false #?

# Print Panel expansion (false, false)
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete (false)
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Resume: Keep windows
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Automatic termination of inactive apps (false)
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Crash reporter (*crashreport or none)
defaults write com.apple.CrashReporter DialogType none

# Help Viewer to non-floating mode (false)
defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Sleep on Idle (# minutes or Off/Never)
sudo systemsetup -setcomputersleep Off > /dev/null

# Check for software updates (7 days)
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable Notification Center and remove the menu bar icon
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Smart quotes (true)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Smart dashes (true)
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
# SSD-specific tweaks (from http://forums.macrumors.com/showthread.php?t=1505922) #
###############################################################################

# Disable local Time Machine snapshots
sudo tmutil disablelocal

# Hibernation (0 = disable, *3 = safe sleep, 25 = no sleep, hibernate only)
sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
sudo rm /Private/var/vm/sleepimage
# Create a zero-byte file instead…
sudo touch /Private/var/vm/sleepimage
# …and make sure it can’t be rewritten
sudo chflags uchg /Private/var/vm/sleepimage

# Sudden motion sensor (0 to disable)
sudo pmset -a sms 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: Tap to click (user and login)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: Right click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Enable “natural” (iOS-style) scrolling (true)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Keyboard press and hold (*true = hold for diacritic, false = repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard repeat rate (value * 15ms)
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Locale settings
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# Set the timezone; see `systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "America/New_York" > /dev/null

# Auto-correct (true)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################

# Password after screensaver/sleep (false, 5)
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screenshot location
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Screenshots format (BMP, GIF, JPG, PDF, *PNG, TIFF)
defaults write com.apple.screencapture type -string "png"

# Screenshot shadows (false)
defaults write com.apple.screencapture disable-shadow -bool true

# Subpixel font rendering on non-Apple LCDs (1 = Light, 2 = Medium, 3 = Strong)
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons (false)
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: Window animations and Get Info animations (false)
defaults write com.apple.finder DisableAllAnimations -bool false

# Default location for new Finder windows
# Computer 	PfCm		None
# Volume 	PfVo		file:///
# Home 	PfHm		file://${HOME}/
# Desktop 	PfDe		file://${HOME}/Desktop/
# Documents 	PfDo 		file://${HOME}/Documents/
# *All My Files 	PfAf		file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch
# Other path 	PfLo 		file:///full/path/here/
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Desktop: Icons
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: Show hidden files (see show/hide aliases - false)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: Show filename extensions (false)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: Show status bar (false)
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show path bar (false)
defaults write com.apple.finder ShowPathbar -bool true

# Finder: Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Finder: Display full POSIX path as window title (false)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: Search Scope (*???? = This Mac, SCcf = Current Folder, ???? = Shared)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Warn when changing file extension (true)
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Finder: Spring loading directories (dragging onto folder opens it)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Finder: Spring loading directory delay
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info below icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Finder: View mode (Nlsv = List, *icnv = Icon, clmv = Column, Flwv = Flow)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Warn before emptying trash (true)
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely (false)
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
 General -bool true \
 OpenWith -bool true \
 Privileges -bool true

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/check.icns
#[ -e "$file" ] && mv -f "$file" "$file.bak"
#unset file

###############################################################################
# Dock & hot corners                                                          #
###############################################################################

# Highlight hover the grid view of a stack (true)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Icon size (64 pixels)
defaults write com.apple.dock tilesize -int 36

# Minimize/maximize window effect (*genie, scale, suck)
defaults write com.apple.dock mineffect -string "genie"

# Minimize windows into their application’s icon (false)
defaults write com.apple.dock minimize-to-application -bool false

# Spring load all the things!
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Open application indicators (true)
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array ""

# Opening window animations
defaults write com.apple.dock launchanim -bool true

# Mission Control: Animation speed
defaults write com.apple.dock expose-animation-duration -float 0.1

# Mission Control: Group windows (true)
defaults write com.apple.dock expose-group-by-app -bool false

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true #?

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true #?

# Spaces: Rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false #?

# Remove the auto-hiding Dock delay
defaults write com.apple.Dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Autohide Dock (false)
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true #?

# Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete #?

# Add iOS Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app"

# Add a spacer to the left side of the Dock (where the applications are)
defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

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
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

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
 '{"enabled" = 1;"name" = "DIRECTORIES";}' \
 '{"enabled" = 1;"name" = "PDF";}' \
 '{"enabled" = 1;"name" = "FONTS";}' \
 '{"enabled" = 0;"name" = "DOCUMENTS";}' \
 '{"enabled" = 0;"name" = "MESSAGES";}' \
 '{"enabled" = 0;"name" = "CONTACT";}' \
 '{"enabled" = 0;"name" = "EVENT_TODO";}' \
 '{"enabled" = 0;"name" = "IMAGES";}' \
 '{"enabled" = 0;"name" = "BOOKMARKS";}' \
 '{"enabled" = 0;"name" = "MUSIC";}' \
 '{"enabled" = 0;"name" = "MOVIES";}' \
 '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
 '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
 '{"enabled" = 0;"name" = "SOURCE";}' \
 '{"enabled" = 1;"name" = "MENU_OTHER";}' \
 '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

###############################################################################
# Mac App Store #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true #?

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Disable GateKeeper
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Bookmarks bar
defaults write com.apple.Safari ShowFavoritesBar -bool false #?

# Sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false #?

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()" #?

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Send and reply animations in Mail.app (true, true)
defaults write com.apple.mail DisableReplyAnimations -bool false
defaults write com.apple.mail DisableSendAnimations -bool false

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false #?

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\\U21a9"

# Inline attachments (true)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool false

# Spell checking
#defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='Solarized Dark xterm-256color';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
	open "${HOME}/init/${TERM_PROFILE}.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded
	defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
	defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;

# Mouse focus for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it with[out] clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool false
defaults write org.x.X11 wm_ffm -bool false

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Activity Monitor #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true #?

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" #?
defaults write com.apple.ActivityMonitor SortDirection -int 0 #?

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "cfprefsd" "Contacts" "Dock" "Finder" "Mail" \
	"Safari" "SystemUIServer" "Terminal" "iCal"; do
	killall "$app" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."