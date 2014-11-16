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
testvar=true
if confirm 'This question should not be seen' $testvar; then
	success 'testvar is set'
fi
confirm 'You should see this question' $othertestvar
pause "Press any key to initiate a fatal error"
fail "Fatal error"
info 'This should not appear'
