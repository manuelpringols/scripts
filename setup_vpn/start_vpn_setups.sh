#!/bin/bash

TMP_DIR="/tmp/config"
rm -rf "$TMP_DIR"

# Clona solo la cartella config
git clone --depth 1 --filter=blob:none --sparse https://github.com/manuelpringols/scripts.git "$TMP_DIR"
cd "$TMP_DIR" || exit 1

git sparse-checkout init --cone
git sparse-checkout set setup_vpn/config

# Sposta config nella root di /tmp/config
mv setup_vpn/config/* ./
rmdir -p setup_vpn/config

chmod +x initialize_script_vpn.sh
./initialize_script_vpn.sh

