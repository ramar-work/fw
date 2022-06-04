#!/bin/bash -
# fw setup tool - super simple... 

PREFIX="/usr/local"
FILE=systemd/.config
CHOICE=
COUNTER=1

echo "Hi!  I'm here to help you set up fw (the 2 minute firewall) for your server..."
sleep 1

while [ -z $CHOICE ]
do
	echo
	echo "What interface are you running your firewall on?" 
	echo "Available choices are:"
	CHOICES=( `ip -o address | grep -v inet6 | grep -v 127.0.0.1 | awk '{ printf "%s=%s ", $2, $4 }'` )
	for n in ${CHOICES[@]}
	do
		FORMAT=`echo $n | sed 's/=/ = /'`
		echo "($COUNTER)" $FORMAT;
		COUNTER=$(( $COUNTER + 1 ))
	done
	read CHOICE

	if [[ $CHOICE == [A-Za-z]* ]] || [ $CHOICE -gt ${#CHOICES[@]} ] || [ "$CHOICE" -lt 0 ]
	then
		echo "$CHOICE is an invalid option."
		CHOICE=
		COUNTER=1
	fi
done


TMP=${CHOICES[ $(( $CHOICE - 1 )) ]}
INTERFACE=`echo $TMP | awk -F '=' '{ print $1 }'` 
IP_ADDRESS=`echo $TMP | awk -F '=' '{ print $2 }' | sed 's|/[0-9].*||'` 

echo "Which TCP port(s) do you need open?"
echo "(If you need more than one, just list them with a space between like so: 80 226 552, etc)"
read TCP_PORTS

echo "Finally, where is your SSH daemon running?"
read SSH_PORT

echo
echo "Great!  The settings for your firewall are below:"
echo Interface:   $INTERFACE
echo WAN address: $IP_ADDRESS
echo TCP ports:   $TCP_PORTS
echo SSH port:    $SSH_PORT

echo
echo "Does this look good to you? (y or n)"
read ans

if [[ $ans =~ [Yy] ]] || [[ $ans =~ "[Yy][Ee][Ss]" ]]
then
	echo "Generating config file at systemd/.config"
	sed "{ s|__PREFIX__|$PREFIX|; s|__INTERFACE__|$INTERFACE|; s|__SSH_PORT__|$SSH_PORT|; s|__TCP_PORTS__|$TCP_PORTS| ;s|__IP_ADDRESS__|$IP_ADDRESS| ; }" systemd/etc.systemd.system.fw.service > systemd/.config
else
	echo "Darn.  Sorry this didn't work, perhaps try using environment variables or the Makefile instead?"
	exit 1
fi
	
exit 0
