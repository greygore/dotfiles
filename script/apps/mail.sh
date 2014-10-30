#!/usr/bin/env bash

###############################################################################
# Mail                                                                        #
###############################################################################

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\\U21a9"

# Inline attachments (true)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool false

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false #?

# Send and reply animations in Mail.app (true, true)
defaults write com.apple.mail DisableReplyAnimations -bool false
defaults write com.apple.mail DisableSendAnimations -bool false

# Spell checking
#defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
