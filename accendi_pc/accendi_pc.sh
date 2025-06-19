#!/bin/bash

# Indirizzo MAC del dispositivo da risvegliare
MAC_ADDRESS="b0:41:6f:0f:d6:39"

# Comando Wake-on-LAN
wakeonlan -i 192.168.1.255 $MAC_ADDRESS

echo "Pacchetto Wake-on-LAN inviato a $MAC_ADDRESS"

