 #!/usr/bin/bash


'''
	Use it with your own risk      			      
This script will dynamically generate data value base upon date and 
 time retrieved from system, dummy IP addresses, ports, and serial number  
    need to rely on system to open udp network connectivity                                                          
     	$ bash log_shooter.sh 10.47.11.248 5 2  	    
'''

source ./cal_ip.sh
source ./input_check.sh

# retrieve destination target IP address
k_value=$1

# retrieve first argument and validate value with input_check function
l_value=$(checkinput $2)

# retrieve second argument and validate value with input_check function
j_value=$(checkinput $3)

# final check return code from input_check function 
if [ "$l_value" == "d" ]; then
	echo "invalid input valid"
	echo "example: create_addr_a.sh x.x.x.x <int> [1 | 2]"
	echo "acceptable IPv4 address "
	echo "acceptable integer 1-999999 "
	echo "selective option for log type"
	echo "1 - FortiGate IPS"
	echo "2 - Cisco ASA"
	exit 1;
fi;

if [ "$j_value" == "d" ]; then
	echo "invalid input valid"
	echo "example: create_addr_a.sh <int> [1 | 2]"
	echo "acceptable integer 1-9999999 "
	echo "selective option for log type"
	echo "1 - FortiGate IPS"
	echo "2 - Cisco ASA"
	exit 1;
fi;

SRCP_NUM=50100				# SOURCE PORT NUMBER TO STARTS OFF
ISERIAL_NUM=758514639		# LOG ENTRY SERIAL NUMBER TO STARTS OFF

FIRST_IP=223.109.0.0		# IP ADDRESS TO STARTS OFF
IP=$FIRST_IP				# ASSIGN TO IP VARIABLE

exec 7>/dev/udp/$k_value/514		# open udp connection to target host

# case statement. prompt user to select log format

case "$3" in

# iterate with for loop base on user input number

1)
for ((i = 0 ; i < $l_value ; i++)); do
	
	# pause 0.2s for each iteration
	sleep 0.5

	# increment source port number and serial number by 1
	let "SRCP_NUM+=1"
	let "ISERIAL_NUM+=1"

	# increment IP address by call nextip function
	IP=$(nextip $IP)

	# get system time with month and year format
	MY_MTIME=`date +%Y-%m-%d`

	# get system time with T format
	MY_CTIME=`date +%T`

	# print syslog sample output 
	result=$(printf "%s\n" "<185>date=$MY_MTIME "time=$MY_CTIME " devname=GN-IPS-4 devid=FGT37D9P00000005 logid=0419016384 type=utm subtype=ips eventtype=signature level=alert vd=TP severity=critical srcip=234.209.91.49 srccountry="Netherlands" dstip="$IP " srcintf="port10" dstintf="port9" policyid=2000 sessionid=1816135564 action=dropped proto=17 service="udp/42448" attack="Netcore.Netis.Devices.Hardcoded.Password.Security.Bypass" srcport="$SRCP_NUM " dstport=53413 direction=outgoing attackid=42781 profile="GSN" ref="http://www.fortinet.com/ids/VID42781" incidentserialno="$ISERIAL_NUM " msg="backdoor\:  Netcore.Netis.Devices.Hardcoded.Password.Security.Bypass," crscore=50 crlevel=critical")

	# echo with std output
	echo $result
	echo $result >&7
	
done;
exec 7>&-		# close udp connection
exit 0;
;;

2)
for ((i = 0 ; i < $l_value ; i++)); do
	
	# pause 0.2s for each iteration
	sleep 0.5

	# increment source port number and serial number
	let "SRCP_NUM+=1"
	let "ISERIAL_NUM+=1"

	# increment IP address and date
	IP=$(nextip $IP)

	# get system time with month and year format
	MY_MTIME=`date +%Y-%m-%d`

	# get system time with T format
	MY_CTIME=`date +%T`

	# print syslog sample output 
	result=$(printf "%s\n" "<134>$MY_MTIME $MY_DTIME $MY_CTIME: %ASA-6-302013: Build outbound TCP connection 76118 for outside:$IP/80 ($IP/80) to inside:192.168.20.31/3530 (192.168.0.1/5957)")

	# echo with std output
	echo $result
	echo $result >&7
	
done;
exec 7>&-		# close udp connection
exit 0;
;;
esac
