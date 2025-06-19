#!/bin/bash

# Configura utente remoto
REMOTE_USER="computer"  # <-- Sostituisci con il tuo utente
REMOTE_HOST="192.168.1.50"

# Esegui il comando di spegnimento remoto
ssh ${REMOTE_USER}@${REMOTE_HOST} "shutdown /s /t 0"
