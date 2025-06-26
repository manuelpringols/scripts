#!/bin/bash
set -euo pipefail

# === CONFIG ===
GITHUB_USER="manuelpringols"
GITHUB_REPO="pitonzi"
REPO_API_URL="https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/contents"
AUTH_HEADER=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH_HEADER=(-H "Authorization: token $GITHUB_TOKEN")

# === COLORI ===
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

run_resolve_deps() {
  local local_path="./resolve_deps.py"
  local tmp_path="/tmp/resolve_deps.py"

  if [[ -f "$local_path" ]]; then
    python3 "$local_path" "$1"
  else
    # Scarica resolve_deps.py se non esiste in locale
    if [[ ! -f "$tmp_path" ]]; then
      echo -e "${CYAN}📥 Scarico resolve_deps.py da remoto...${RESET}"
      curl -fsSL "https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/master/resolve_deps.py" -o "$tmp_path"
      chmod +x "$tmp_path"
    fi
    python3 "$tmp_path" "$1"
  fi
}

while true; do
  echo -e "\n${MAGENTA}📁 Seleziona una cartella:${RESET}"
  folders_json=$(curl -s "${AUTH_HEADER[@]}" "$REPO_API_URL")

  if echo "$folders_json" | grep -q 'API rate limit exceeded'; then
    echo -e "${RED}❌ API rate limit superato. Esporta GITHUB_TOKEN per aumentare il limite.${RESET}"
    exit 1
  fi

  folders=$(echo "$folders_json" | jq -r '.[] | select(.type == "dir") | .name')
  selected_folder=$(echo -e "🔙 Torna indietro\n$folders" | fzf --height=20 --layout=reverse --border --prompt="📁 Cartella > ")

  [[ -z "$selected_folder" || "$selected_folder" == "🔙 Torna indietro" ]] && echo -e "${RED}❌ Annullato.${RESET}" && exit 1
  echo -e "${GREEN}✅ Hai scelto: $selected_folder${RESET}"

  scripts_json=$(curl -s "${AUTH_HEADER[@]}" "$REPO_API_URL/$selected_folder")
  scripts=$(echo "$scripts_json" | jq -r '.[] | select(.name | endswith(".py")) | .name')
  selected_script=$(echo -e "🔙 Torna indietro\n$scripts" | fzf --height=20 --layout=reverse --border --prompt="🐍 Script Python > ")

  [[ -z "$selected_script" || "$selected_script" == "🔙 Torna indietro" ]] && continue

  # Ottieni URL raw script
  script_url=$(echo "$scripts_json" | jq -r ".[] | select(.name == \"$selected_script\") | .download_url")
  if [[ -z "$script_url" ]]; then
    echo -e "${RED}❌ Impossibile ottenere l'URL dello script selezionato.${RESET}"
    exit 1
  fi

  echo -e "${GREEN}▶️ Script selezionato: $selected_script${RESET}"
  echo -e "${CYAN}▶️ URL script: $script_url${RESET}"
done

# Crea ambiente virtuale temporaneo
venv_dir=$(mktemp -d)
echo -e "${CYAN}🛠 Creo ambiente virtuale in $venv_dir${RESET}"
python3 -m venv "$venv_dir"
source "$venv_dir/bin/activate"

# Aggiorna pip e setuptools nel venv
pip install --upgrade pip setuptools >/dev/null

# Scarica lo script in temp file
temp_script=$(mktemp --suffix=".py")
curl -fsSL "$script_url" -o "$temp_script"
chmod +x "$temp_script"

echo -e "${CYAN}Premi INVIO per eseguire senza argomenti, oppure digita 'INS' per aggiungere argomenti.${RESET}"

while true; do
  read -r key

  if [[ -z "$key" ]]; then
    # Invio premuto senza input
    echo -e "${CYAN}📦 Risolvo e installo dipendenze con resolve_deps.py...${RESET}"
    deps=$(run_resolve_deps "$temp_script")
    if [[ -n "$deps" ]]; then
      echo -e "${CYAN}📦 Installazione moduli pip: $deps${RESET}"
      pip install $deps
    fi

    echo -e "${GREEN}▶️ Eseguo script senza argomenti...${RESET}"
    python3 "$temp_script"

    deactivate
    rm -rf "$venv_dir" "$temp_script"
    exit 0

  elif [[ "$key" == "INS" ]]; then
    echo -e "\n${MAGENTA}⌨️ Inserisci gli argomenti da passare allo script:${RESET}"
    read -rp "Args: " user_args

    echo -e "${CYAN}📦 Risolvo e installo dipendenze con resolve_deps.py...${RESET}"
    deps=$(python3 resolve_deps.py "$temp_script")
    if [[ -n "$deps" ]]; then
      echo -e "${CYAN}📦 Installazione moduli pip: $deps${RESET}"
      pip install $deps
    fi

    echo -e "${GREEN}▶️ Eseguo script con argomenti:${RESET} $user_args"
    python3 "$temp_script" $user_args

    deactivate
    rm -rf "$venv_dir" "$temp_script"
    exit 0

  else
    echo -e "${YELLOW}⚠️ Input non valido. Premi INVIO oppure digita 'INS' e premi INVIO.${RESET}"
  fi
done
