#!/bin/bash

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

GREEN="\e[1;32m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
RED="\e[1;31m"
RESET="\e[0m"

echo -e "\n${YELLOW}📝 Aggiungo tutti i file modificati...${RESET}"
git add .

# Controllo se ci sono cambiamenti da committare
if git diff --cached --quiet; then
  echo -e "${RED}⚠️  Nessuna modifica da committare.${RESET}"
else
  # Se non passo argomento, chiedo interattivamente il commit_msg
  if [ $# -eq 0 ]; then
    echo -ne "${CYAN}👉 Inserisci il messaggio di commit:${RESET} "
    read commit_msg
  else
    commit_msg="$1"
  fi

  if [ -z "$commit_msg" ]; then
    echo -e "${RED}❌ Errore: messaggio di commit vuoto. Uscita.${RESET}"
    exit 1
  fi

  echo -e "${YELLOW}💾 Commit in corso con il messaggio:${RESET} \"${GREEN}$commit_msg${RESET}\""
  git commit -m "$commit_msg"
fi

echo -e "${CYAN}🌐 Controllo se ci sono modifiche da pushare...${RESET}"

UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
if [ -z "$UPSTREAM" ]; then
  echo -e "${YELLOW}⚠️  Branch upstream non configurato. Eseguo push su origin master.${RESET}"
  loading_bar 1.5
  git push origin master
else
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "@{u}")
  BASE=$(git merge-base @ "@{u}")

  if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}✅ Branch locale e remoto sono aggiornati, niente da pushare.${RESET}"
  elif [ "$LOCAL" = "$BASE" ]; then
    echo -e "${RED}❌ Il branch remoto è più avanti rispetto a quello locale. Fai un pull prima di pushare.${RESET}"
    exit 1
  elif [ "$REMOTE" = "$BASE" ]; then
    echo -e "${CYAN}🚀 Push delle modifiche in corso...${RESET}"
    loading_bar 1.5
    git push
  else
    echo -e "${YELLOW}⚠️  Branch locale e remoto hanno divergenze. Fai un pull manuale.${RESET}"
    exit 1
  fi
fi

echo -e "\n${GREEN}🎉 Operazione completata con successo!${RESET}\n"
