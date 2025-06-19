#!/bin/bash

echo "========================================="
echo "Script per inviare un pacchetto Wake-on-LAN"
echo "Questo comando serve a risvegliare un dispositivo sulla rete locale"
echo "utilizzando il suo MAC address."
echo "-----------------------------------------"

# Rileva il sistema operativo
OS=$(uname)
echo "Sistema operativo rilevato: $OS"

# Verifica se il comando wakeonlan è installato
if ! command -v wakeonlan &> /dev/null
then
    echo ""
    echo "Errore: il comando 'wakeonlan' non è installato."
    echo "Per far funzionare questo script, devi installarlo."
    echo ""

    if [[ "$OS" == "Linux" ]]; then
        echo "Su Linux (Debian/Ubuntu) puoi installarlo con:"
        echo "    sudo apt update && sudo apt install wakeonlan"
    elif [[ "$OS" == "Darwin" ]]; then
        echo "Su macOS puoi installarlo con Homebrew:"
        echo "    brew install wakeonlan"
    else
        echo "Per il tuo sistema operativo, cerca come installare 'wakeonlan'."
    fi
    exit 1
fi

# Indirizzo MAC del dispositivo da risvegliare
MAC_ADDRESS="b0:41:6f:0f:d6:39"

# Invia il pacchetto Wake-on-LAN sulla broadcast della rete locale
wakeonlan -i 192.168.1.255 $MAC_ADDRESS

echo ""
echo "Pacchetto Wake-on-LAN inviato a $MAC_ADDRESS"
echo "========================================="
