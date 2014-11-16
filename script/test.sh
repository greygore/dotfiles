#/usr/bin/env bash
source ./lib.sh

question 'What is your name?'
pause
warning 'We need to check your name'
if confirm "Is your name $answer?"; then
	info "Your name is $answer"
	success "We have determined your name!"
else
	info "Your name is not $answer"
	error "Your name is still unknown"
fi
password 'This is a password request:'
defaultval='BLUE'
question 'This question should not be seen' $defaultval "The default value is $defaultval"
testvar=true
confirm 'This confirm should not be seen' "$testvar"
confirm 'This confirm should also not be seen' $testvar 'Testvar set'
confirm 'You should see this confirm' $othertestvar
pause "Press any key to initiate a fatal error"
fail "Fatal error"
info 'This should not appear'
