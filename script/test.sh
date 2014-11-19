#/usr/bin/env bash
[ -z "$DOTFILES_ROOT" ] && { echo "ERROR: DOTFILES_ROOT needs to be set"; exit 1; }
source $DOTFILES_ROOT/script/lib.sh

echo

echo "(TEST) This should display an information message:"
info 'This is an information message'
echo

echo "(TEST) This should be a simple question:"
question 'What is your name?'
echo "The answer is '$answer'"
echo

echo "(TEST) The next question should be bypassed because a default value was supplied"
favorite_color='Blue'
question 'What is your favorite color?' $favorite_color
echo "The answer is '$answer'"
echo

echo "(TEST) The next question should be asked, because no default value is found"
question 'What is your zip code?' $zipcode
echo "The answer is '$answer'"
echo

echo "(TEST) The next question should print an info statement instead of a question"
state='Georgia'
question 'What state do you live in?' $state "You live in $state!"
echo "The answer is '$answer'"
echo

echo "(TEST) The next question should be asked, because no default value is found"
question 'What is your favorite number?' "$favorite_number" "Your favorite number is $favorite_number!"
echo "The answer is '$answer'"
echo

echo "(TEST) The password prompt shouldn't echo the input"
password 'Please enter a fake password:'
echo "The password is '$answer'"
echo

echo "(TEST) The password prompt shouldn't appear when a default is provided"
default_password="pencil"
password 'Please enter another fake password:' "$default_password"
echo "The password is '$answer'"
echo

echo "(TEST) The password prompt should appear when the default isn't available"
password 'Please enter yet another fake password:' "$missing_password"
echo "The password is '$answer'"
echo

echo "(TEST) The password prompt should display an info message when a default is provided"
another_password="apple"
password 'Please enter a fourth fake password:' "$another_password" 'A password was provided.'
echo "The password is '$answer'"
echo

echo "(TEST) A confirmation dialog should return 0 (success) when 'y' is entered"
if confirm "Are you running tests?"; then
	echo "PASS"
else
	echo "FAIL"
fi
echo

echo "(TEST) A confirmation dialog should return 1 (failure) when 'n' is entered"
if confirm 'Are you a dog?'; then
	echo "FAIL"
else
	echo "PASS"
fi
echo

echo "(TEST) A confirmation dialog should still be displayed if the default is empty"
blank_default=''
if confirm 'Can you read this?' "$blank_default"; then
	echo "PASS"
else
	echo "FAIL"
fi
echo

echo "(TEST) A confirmation dialog should not be displayed if a default is 'y'"
confirmed='y'
if confirm 'Can you read this?' "$confirmed"; then
	echo "PASS"
else
	echo "FAIL"
fi
echo

echo "(TEST) A confirmation dialog should not be displayed if a default is provided but isn't 'y'"
not_a_y='elephant'
if confirm 'Can you read this?' "$not_a_y"; then
	echo "FAIL"
else
	echo "PASS"
fi
echo

echo "(TEST) A confirmation dialog should only display an info message if a default 'y' is provided with an additional message parameter"
also_confirmed='y'
if confirm 'Can you read this?' "$also_confirmed" 'The default value was successfully provided!'; then
	echo "PASS"
else
	echo "FAIL"
fi
echo

echo "(TEST) A confirmation dialog should not display an info message if the default value is not 'y'"
still_not_a_y='Hippo'
if confirm 'Can you read this?' "$still_not_a_y" "This message shouldn't appear"; then
	echo "FAIL"
else
	echo "PASS"
fi
echo

echo "(TEST) Pause without any parameters should have a default message"
pause
echo

echo "(TEST) Pause with a parameter should use that as the message"
pause "To continue with the tests, press any key"
echo

echo "(TEST) Success messages should display in green with a check mark"
success "This is a success message"
echo

echo "(TEST) Warning messages should appear in yellow with an exclamation"
warning "This is a warning message"
echo

echo "(TEST) Error messages should appear in red with an X"
error "This is an error message"
echo

echo "(TEST) A failure should appear in red with an X and immediately exit"
fail "This is a failure"
echo

echo "(TEST) This should not appear"