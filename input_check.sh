#!/bin/bash

# Check user int input with 7 digit function

function checkinput(){
	v_in=$1
	
	# check if input value matched interger 0-9 and 7 digit length
	if [[ $v_in =~ ^[0-9]{1,6}$ ]] ; 
	then
		echo "$v_in"
	else
		echo "d"
	fi;
}	
