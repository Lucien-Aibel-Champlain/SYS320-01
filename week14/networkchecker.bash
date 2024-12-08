#!/bin/bash

myIP=$(bash "../week9/myip.sh")


# Todo-1: Create a helpmenu function that prints help for the script
function HelpMenu(){
	echo "Usage: "
	echo "Argument 1: '-n' or '-s'"
	echo "Picks which tool to use for the scan."
	echo "-n: NMAP"
	echo "-s: ss (aka Netstat)"
	echo ""
	echo "Argument 2: 'internal' or 'external'"
	echo "Determines whether the command surveys incoming ("
	echo "ex: 'bash $0 -n internal' for an internal nmap scan"
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}


# Only IPv4 ports listening from network
function ExternalListeningPorts(){
	elpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/'$myIP'/ {print $5,$9}' | tr -d "\"")
}


# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
	ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
}

if [[ "${#}" != "2" ]]; then
	HelpMenu
else
	while getopts ":n:s:" opt; do
		case "$opt" in
			n)
			case "$OPTARG" in
				internal)
					InternalNmap
					echo "$rin"
				;;
				external)
					ExternalNmap
					echo "$rex"
				;;
				*)
					HelpMenu
				;;
			esac
			;;
			s)
			case "$OPTARG" in
				internal)
					InternalListeningPorts
					echo "$ilpo"
				;;
				external)
					ExternalListeningPorts
					echo "$elpo"
				;;
				*)
					HelpMenu
				;;
			esac
			;;
			*)
			HelpMenu
			;;
		esac
	done
fi


