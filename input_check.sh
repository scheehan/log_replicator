#!/bin/bash

function checkinput(){
	v_in=$1

	if [[ $v_in =~ ^[0-9]{1,6}$ ]] ; 
	then
		echo "$v_in"
	else
		echo "d"
	fi;
}
