#!/bin/bash

# Indirizzo MssssssssssssssAC del dispositivo da risvegliare
MAC_ADDRESS="00:d8:61:fc:80:10"

# Comando Wake-on-LAN
wakeonlan -i 192.168.1.255 $MAC_ADDRESS

echo "Pacchetto Wake-on-LAN inviato a $MAC_ADDRESS"

