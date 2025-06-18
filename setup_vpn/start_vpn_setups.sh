#!/bin/bash

# Percorso temporaneo
TMP_DIR="/tmp/setup_vpn"

# Pulizia eventuale directory precedente
rm -rf "$TMP_DIR"

# Clona solo la cartella necessaria usando sparse-checkout
git clone --depth 1 --filter=blob:none --sparse https://github.com/manuelpringols/scripts.git "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# Inizializza sparse-checkout per solo la cartella 'setup_vpn'
git sparse-checkout init --cone
git sparse-checkout set setup_vpn

# Entra nella cartella specifica
cd setup_vpn || exit 1

# Copia i file nella directory /tmp
cp /config/script_vpn.py /tmp/
cp /config/requirements.txt /tmp/

# Dai permessi di esecuzione allo script di inizializzazione
chmod +x initialize_script_vpn.sh

# Avvia lo script finale
/config/initialize_script_vpn.sh

# (Facoltativo) Cancella la cartella temporanea dopo l'esecuzione
rm -rf "$TMP_DIR"
