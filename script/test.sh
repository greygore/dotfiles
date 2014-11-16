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
testvar="y"
if confirm 'This confirm should not be seen' "$testvar"; then
	success 'Confirmation param test 1'
else
	error 'Confirmation param test 1'
fi
testvar='n'
if confirm 'This confirm should also not be seen' $testvar 'Testing confirm third param...'; then
	error 'Confirmation param test 2'
else
	success 'Confirmation param test 2'
fi
confirm 'This confirm should also not be seen' $testvar 'Testvar set'
confirm 'You should see this confirm' $othertestvar
pause "Press any key to initiate a fatal error"
fail "Fatal error"
info 'This should not appear'
