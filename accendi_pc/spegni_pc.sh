#!/bin/bash

# Configura utente remoto
REMOTE_USER="manuel"  # <-- Sostituisci con il tuo utente
REMOTE_HOST="10.0.0.37"

# Esegui il comando di spegnimento remoto
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo shutdown now"

