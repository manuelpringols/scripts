#!/bin/bash

TMP_DIR="/tmp/config"
rm -rf "$TMP_DIR"

echo "[+] Clonazione repository (solo cartella config)..."
git clone --depth 1 --filter=blob:none --sparse https://github.com/manuelpringols/scripts.git "$TMP_DIR"
if [ $? -ne 0 ]; then
    echo "❌ Clone fallito."
    exit 1
fi

cd "$TMP_DIR" || { echo "❌ Directory non trovata"; exit 1; }

echo "[+] Configurazione sparse-checkout..."
git sparse-checkout init --cone
git sparse-checkout set setup_vpn/config
if [ $? -ne 0 ]; then
    echo "❌ Sparse-checkout fallito."
    exit 1
fi

cd setup_vpn/config || { echo "❌ Directory setup_vpn/config non trovata"; exit 1; }

echo "[+] Impostazione permessi su initialize_script_vpn.sh..."
chmod +x initialize_script_vpn.sh

echo "[+] Avvio initialize_script_vpn.sh..."
./initialize_script_vpn.sh
if [ $? -ne 0 ]; then
    echo "❌ Errore durante l'esecuzione di initialize_script_vpn.sh"
    exit 1
fi

