#!/bin/bash

# 🎨 COLORI
RED="\e[31m"
GREEN="\e[92m"
CYAN="\e[96m"
YELLOW="\e[93m"
MAGENTA="\e[95m"
BOLD="\e[1m"
RESET="\e[0m"

# 🔍 Controllo e installazione jq e fzf
install_dependencies() {
  missing=()
  for cmd in jq fzf; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    return 0
  fi

  echo -e "${RED}❌ Mancano i seguenti comandi necessari: ${missing[*]}${RESET}"
  read -rp "Vuoi installarli ora? [y/N]: " answer
  case "$answer" in
    [Yy]* )
      echo "Rilevo sistema operativo e installo i pacchetti..."

      if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS con brew
        if ! command -v brew &>/dev/null; then
          echo -e "${RED}Homebrew non trovato. Installa Homebrew prima di continuare: https://brew.sh/${RESET}"
          exit 1
        fi
        echo "Usando brew per installare: ${missing[*]}"
        brew install "${missing[@]}"
      elif [[ -f /etc/debian_version ]]; then
        # Debian/Ubuntu
        echo "Usando apt per installare: ${missing[*]}"
        sudo apt update && sudo apt install -y "${missing[@]}"
      elif [[ -f /etc/fedora-release ]]; then
        # Fedora
        echo "Usando dnf per installare: ${missing[*]}"
        sudo dnf install -y "${missing[@]}"
      elif [[ -f /etc/arch-release ]]; then
        # Arch Linux
        echo "Usando pacman per installare: ${missing[*]}"
        sudo pacman -S --noconfirm "${missing[@]}"
      else
        echo -e "${RED}Sistema operativo non riconosciuto o installazione automatica non supportata.${RESET}"
        echo "Installa manualmente: ${missing[*]}"
        exit 1
      fi
      ;;
    * )
      echo "Non sono stati installati i pacchetti necessari. Esco."
      exit 1
      ;;
  esac
}

install_dependencies

REPO_API_URL="https://api.github.com/repos/manuelpringols/scripts/contents"
BASE_URL="https://raw.githubusercontent.com/manuelpringols/scripts/master"

# 📦 Header auth (se disponibile)
if [[ -n "$GITHUB_TOKEN" ]]; then
    AUTH_HEADER=(-H "Authorization: token $GITHUB_TOKEN")
else
    echo -e "${YELLOW}⚠️  Nessun token GitHub rilevato. Userai il limite pubblico di 60 richieste/h.${RESET}"
    AUTH_HEADER=()
fi

# ⚡ Titolo iniziale con pixel rossi
# 🎬 Animazione riga per riga
echo -e "${RED}█▀▄▀█${DARK_RED} ██   █▄▄▄▄ ${RED}█▀▄▀█${RESET} ▄█    ▄▄▄▄▀    ▄▄▄▄▀ ██"; sleep 0.1
echo -e "${DARK_RED}█ █ █${RED} █ █  █  4▀ ${DARK_RED}█ █ █${RED} ██ ▀▀▀ █    ▀▀▀ █    █ █"; sleep 0.1
echo -e "${RED}█ ▄ █${DARK_RED} █▄▄█ █▀▀▌  █ ▄ █ ██     █        █    █▄▄█${RESET}"; sleep 0.1
echo -e "${DARK_RED}█   █${RED} █  █ █  █  █   █ ▐█    █        █     █  █"; sleep 0.1
echo -e "   ${RED}█     █   █      █   ▐   ▀        ▀         █"; sleep 0.1
echo -e "  ${DARK_RED}▀     █   ▀      ▀                          █"; sleep 0.1
echo -e "       ${RED}▀                                     ▀${RESET}"; sleep 0.2

# 🖊️ Sottotitolo finale
echo -e "\n${CYAN}${BOLD}SCRIPT MARMITTA - powered by FATT E CAZZ TUOJ 😈${RESET}\n"

# 🗂️ Scegli cartella
while true; do
    echo -e "\n${MAGENTA}📁 Seleziona una cartella:${RESET}"
    folders_json=$(curl -s "${AUTH_HEADER[@]}" "$REPO_API_URL")

    if echo "$folders_json" | grep -q 'API rate limit exceeded'; then
        echo -e "${RED}❌ API rate limit superato. Esporta GITHUB_TOKEN per aumentare il limite.${RESET}"
        echo -e "${CYAN}Esempio:${RESET} export GITHUB_TOKEN=ghp_tuoTokenQui"
        exit 1
    fi

    folders=$(echo "$folders_json" | jq -r '.[] | select(.type == "dir") | .name')
selected_folder=$(echo -e "🔙 Torna indietro\n$folders" | fzf --height=15 --layout=reverse  --border --prompt="📁 Cartella > " --ansi --color=fg:white,bg:black,hl:red,pointer:green,marker:yellow --color=fg:#d6de35,bg:#121212,hl:#5f87af   --color=fg+:#f02bc9,bg+:#5c00e6,hl+:#5fd7ff

 )


    [[ -z "$selected_folder" || "$selected_folder" == "🔙 Torna indietro" ]] && echo -e "${RED}❌ Annullato.${RESET}" && exit 1

    echo -e "${GREEN}✅ Hai scelto cartella: $selected_folder${RESET}"

    # 📜 Scegli script
    echo -e "\n${MAGENTA}📜 Seleziona uno script da eseguire in ${YELLOW}${selected_folder}${RESET}:"
    scripts_json=$(curl -s "${AUTH_HEADER[@]}" "$REPO_API_URL/$selected_folder")

    if echo "$scripts_json" | grep -q 'API rate limit exceeded'; then
        echo -e "${RED}❌ API rate limit superato durante il caricamento degli script.${RESET}"
        exit 1
    fi

    scripts=$(echo "$scripts_json" | jq -r '.[] | select(.name | endswith(".sh")) | .name')
selected_script=$(echo -e "🔙 Torna indietro\n$scripts" | fzf --height=15 --layout=reverse --border --prompt="📜 Script > " --ansi --color=fg:white,bg:black,hl:red,pointer:green,marker:yellow )

    [[ -z "$selected_script" || "$selected_script" == "🔙 Torna indietro" ]] && continue

    echo -e "${GREEN}✅ Hai scelto script: $selected_script${RESET}"

    # 📡 Metodo di download
    downloader="curl -fsSL"
    URL_FULL="$BASE_URL/$selected_folder/$selected_script"

    echo -e "\n${CYAN}🚀 Esecuzione comando:${RESET}"
    echo -e "${YELLOW}bash -c \"\$($downloader $URL_FULL)\"${RESET}"

    echo -e "${CYAN}Premi INVIO per eseguire lo script"
    echo -e "Premi ${YELLOW}INS${CYAN} per inserire parametri"
    echo -e "Premi ${RED}Ctrl+C${CYAN} per annullare...${RESET}"

    read -rsn1 key
    if [[ $key == $'\e' ]]; then
        read -rsn2 key2
        if [[ $key2 == "[2" ]]; then
            read -rsn1 tilde
            if [[ $tilde == "~" ]]; then
                echo -e "\n${MAGENTA}⌨️ Inserisci gli argomenti da passare allo script:${RESET}"
                read -rp "Args: " user_args

                temp_script=$(mktemp)
                echo -e "\n${GREEN}⬇️ Scarico script temporaneo...${RESET}"
                curl -fsSL "$URL_FULL" -o "$temp_script" || { echo -e "${RED}Errore nel download dello script.${RESET}"; exit 1; }
                chmod +x "$temp_script"

                echo -e "\n${GREEN}▶️ Eseguo:${RESET} ${YELLOW}$temp_script $user_args${RESET}"
                "$temp_script" $user_args
                rm "$temp_script"
                exit 0
            fi
        fi
    fi

    echo -e "\n${GREEN}▶️ Eseguo senza parametri...${RESET}"
    bash -c "$($downloader $URL_FULL)"
    exit 0
done

