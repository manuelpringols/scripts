#!/bin/bash

# Funzione loading bar con colori e emoji
loading_bar() {
  local duration=$1
  echo -n -e "\n🚀  Caricamento: ["
  for ((i=0; i<duration; i++)); do
    local color=$((31 + i % 6))
    echo -ne "\e[48;5;${color}m \e[0m"
    sleep 0.1
  done
  echo -e "]\n"
}

# Colori per testo (foreground)
GREEN="\e[1;32m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
RESET="\e[0m"

# Se non passo argomento, chiedo interattivamente
if [ $# -eq 0 ]; then
  echo -ne "${CYAN}👉 Inserisci il messaggio di commit:${RESET} "
  read commit_msg
else
  commit_msg="$1"
fi

# Se l'utente non scrive nulla (stringa vuota), esco
if [ -z "$commit_msg" ]; then
  echo -e "${RED}❌ Errore: messaggio di commit vuoto. Uscita.${RESET}"
  exit 1
fi

echo -e "\n${YELLOW}📝 Aggiungo tutti i file modificati...${RESET}"
git add .

echo -e "${YELLOW}💾 Commit in corso con il messaggio:${RESET} \"${GREEN}$commit_msg${RESET}\""
git commit -m "$commit_msg"

echo -e "${CYAN}🌐 Invio delle modifiche al repository remoto...${RESET}"
loading_bar 15  # durata animazione ~4 secondi

git push origin master

echo -e "\n${GREEN}🎉 Operazione completata con successo!${RESET}\n"
