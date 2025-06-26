#!/bin/bash

# 🎨 COLORI
BLUE="\033[1;34m"
GREEN="\e[92m"
CYAN="\e[96m"
YELLOW="\e[93m"
MAGENTA="\e[95m"
BOLD="\e[1m"

ORANGE="\e[38;5;208m"    # arancione (color code 208)
PURPLE="\e[35m"          # viola (magenta più scuro)
LIGHT_GRAY="\e[37m"      # grigio chiaro
DARK_GRAY="\e[90m"       # grigio scuro
RED='\e[38;5;160m'       # rosso sangue vivo ma meno brillante del 203
DARK_RED='\e[38;5;52m'   # rosso scuro bordeaux
BLOOD_RED='\e[38;5;124m' # rosso sangue scuro
BLACK='\e[30m'           # nero per contorno o schizzi
RESET='\e[0m'
BLACK_PITCH='\e[38;5;234m' # nero molto scuro, ma visibile su terminale nero

GREEN_NEON='\033[1;92m'
GREEN_TOXIC='\033[0;92m'
GREEN_DARK='\033[0;32m'
GREEN_SLIME='\033[1;32m'

NC="\033[0m" # No Color

# URL diretto del file raw su GitHub (modifica con il tuo file)
REMOTE_URL="https://raw.githubusercontent.com/manuelpringols/scripts/master/marmitta/marmitta.sh"

# Percorso del file locale
LOCAL_FILE="$(which marmitta)"

function call_pitonzi() {

  echo -e "${RED}██████╗ ${BLOOD_RED}██╗████████╗ $ ${GREEN_NEON} ██████╗ ${GREEN_TOXIC}███╗   ██╗${RED}███████╗${RESET}     ${BLOOD_RED}██${GREEN_SLIME}██████${RESET}"
  sleep 0.05
  echo -e "${DARK_RED}██╔══██╗${RED}██║╚══██╔══╝ ${GREEN_SLIME} ██╔═══██╗${GREEN_NEON}████╗  ██║${DARK_RED}██╔════╝${RESET}  ${BLOOD_RED}██${GREEN_SLIME}╚══███${RESET}"
  sleep 0.05
  echo -e "${RED}██████╔╝${BLOOD_RED}██║   ██║     ${GREEN_TOXIC}██║   ██║${GREEN_SLIME}██╔██╗ ██║${RED}█████╗  ${RESET}     ${BLOOD_RED}██${GREEN_NEON}  ███╔╝${RESET}"
  sleep 0.05
  echo -e "${DARK_RED}██╔═══╝ ${RED}██║   ██║     ${GREEN_TOXIC}██║   ██║${GREEN_DARK}██║╚██╗██║${RED}██╔══╝  ${RESET}       ${BLOOD_RED}██${GREEN_TOXIC} ███╔╝ ${RESET}"
  sleep 0.05
  echo -e "${RED}██║     ${BLOOD_RED}██║   ██║   ${GREEN_SLIME}╚██████╔╝${GREEN_TOXIC}██║ ╚████║${GREEN_NEON}██║${RESET}     ${BLOOD_RED}██${GREEN_SLIME}███████╗${RESET}"
  sleep 0.05
  echo -e "${DARK_RED}╚═╝     ${BLACK_PITCH}╚═╝   ╚═╝   ${GREEN_DARK}╚══════╝ ${BLACK_PITCH}╚═════╝ ${GREEN_DARK}╚═╝  ╚═══╝${GREEN_SLIME}╚═╝${RESET}        ${BLOOD_RED}╚═╝${GREEN_TOXIC}╚══════╝${RESET}"
  sleep 0.1
  echo -e ""
  echo -e "${GREEN_NEON}▀▀▀${RESET} ${GREEN_SLIME}█▀▀▀█${GREEN_TOXIC}   ${GREEN_DARK}PITONZI   ${GREEN_DARK}█▄▄▄█${GREEN_NEON} ▀▀▀${RESET}"
  sleep 0.1

  local BASE_URL="https://raw.githubusercontent.com/manuelpringols/scripts/master"
  local URL_FULL="${BASE_URL}/pitonzi/run_pitonzi.sh"
  curl -fsSL "$URL_FULL" | bash
}

if [[ "$1" == "-py" ]]; then
  shift
  call_pitonzi "$@"
  exit 0   # <-- qui termina lo script subito dopo pitonzi
fi

function slither_psuh() {

  local BASE_URL="https://raw.githubusercontent.com/manuelpringols/scripts/master"
  local URL_FULL="${BASE_URL}/init_git_repo/slither_push_repo.sh"
  sh -c "$(curl -fsSL ${URL_FULL})" -- "$@"
}

if [[ "$1" == "-Gsp" ]]; then
  shift             # Rimuove -Gsp dagli argomenti
  slither_psuh "$@" # Passa tutti gli altri argomenti
  exit 0
fi

function update_marmitta() {
  local BASE_URL="https://raw.githubusercontent.com/manuelpringols/scripts/master"
  local URL_FULL="${BASE_URL}/marmitta/marmitta_update.sh"
  curl -fsSL "$URL_FULL" | bash
}

if [[ "$1" == "-u" ]]; then
  update_marmitta
  exit 0
fi

if [[ "$1" == "-l" || "$1" == "--last" ]]; then
  LAST_SCRIPT=$(cat ~/.marmitta_last_script 2>/dev/null)
  if [[ -z "$LAST_SCRIPT" ]]; then
    echo "❌ Nessuno script eseguito precedentemente."
    exit 1
  fi

  echo "▶️ Rieseguo l'ultimo script:"
  echo "$LAST_SCRIPT"
  bash -c "$(curl -fsSL "$LAST_SCRIPT")"
  exit 0
fi

function print_help() {
  echo -e "${BLUE}m${YELLOW}a${MAGENTA}r${CYAN}m${GREEN}i${PURPLE}t${ORANGE}t${DARK_GRAY}a${RESET} - launcher di script shell"
  echo ""
  echo -e "${YELLOW}Opzioni:${RESET}"
  echo -e "  ${CYAN}-l${RESET}    Riesegue l'ultimo script"
  echo -e "  ${MAGENTA}-t${RESET}    Mostra struttura script e repo"
  echo -e "  ${RED}-h${RESET}    Mostra questa guida"
  echo -e "  ${GREEN}-u${RESET}    Esegue l'aggiornamento richiamando marmitta_update.sh"
  echo -e "  ${ORANGE}-Gsp${RESET}    Esegue lo script slither_push.sh per pushare velocemente su git"

  echo ""
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  print_help
  exit 0
fi

function print_tree() {
  echo -e "${MAGENTA}📁 git_scripts${RESET}"
  echo -e "${MAGENTA}├── accendi_pc${RESET}"
  echo -e "│   ├── ${YELLOW}accendi_pc-pisso.sh${RESET}          ${WHITE}→ Script accensione/spegnimento PC fisso${RESET}"
  echo -e "│   ├── ${YELLOW}accendi_pc.sh${RESET}"
  echo -e "│   ├── ${YELLOW}spegni_pc_fisso.sh${RESET}"
  echo -e "│   └── ${YELLOW}spegni_pc.sh${RESET}"
  echo -e "${MAGENTA}├── arch_install'l${RESET}"
  echo -e "│   └── ${YELLOW}arch-install'l.sh${RESET}            ${WHITE}→ Script installazione Arch Linux${RESET}"
  echo -e "${MAGENTA}├── init_git_repo${RESET}"
  echo -e "│   ├── ${YELLOW}init_git_repo.sh${RESET}             ${WHITE}→ Inizializza repo git${RESET}"
  echo -e "│   └── ${YELLOW}slither_push_repo.sh${RESET}         ${WHITE}→ Script per push rapido${RESET}"
  echo -e "${MAGENTA}├── install-dev-tools${RESET}"
  echo -e "│   └── ${YELLOW}install-dev-tools.sh${RESET}         ${WHITE}→ Installa tool di sviluppo${RESET}"
  echo -e "${MAGENTA}├── marmitta${RESET}"
  echo -e "│   ├── ${YELLOW}marmitta.sh${RESET}                  ${WHITE}→ Launcher script${RESET}"
  echo -e "│   └── ${YELLOW}marmitta_update.sh${RESET}           ${WHITE}→ Aggiorna marmitta${RESET}"
  echo -e "${MAGENTA}├── scp_send${RESET}"
  echo -e "│   └── ${YELLOW}scp_send.sh${RESET}                  ${WHITE}→ Invia file via scp${RESET}"
  echo -e "${MAGENTA}├── service_command${RESET}"
  echo -e "│   └── ${YELLOW}command_service.sh${RESET}           ${WHITE}→ Gestione servizi${RESET}"
  echo -e "${MAGENTA}├── setup_vpn${RESET}"
  echo -e "│   ├── config/"
  echo -e "│   └── ${YELLOW}start_vpn_setups.sh${RESET}          ${WHITE}→ Configura e avvia VPN${RESET}"
  echo -e "${MAGENTA}├── setup_zshrc${RESET}"
  echo -e "│   ├── ${YELLOW}setup_zshrc.sh${RESET}               ${WHITE}→ Setup zshrc personalizzato${RESET}"
  echo -e "│   └── spinal/"
  echo -e "${MAGENTA}├── system_report${RESET}"
  echo -e "│   ├── ${YELLOW}check_fs.sh${RESET}                  ${WHITE}→ Controllo filesystem${RESET}"
  echo -e "│   ├── ${YELLOW}check_security_problems.sh${RESET}  ${WHITE}→ Controllo sicurezza${RESET}"
  echo -e "│   ├── ${YELLOW}high_consumption_processes.sh${RESET} ${WHITE}→ Processi ad alto consumo${RESET}"
  echo -e "│   ├── security_checkSmile.txt"
  echo -e "│   └── ${YELLOW}system_report.sh${RESET}             ${WHITE}→ Report di sistema completo${RESET}"
  echo -e "${MAGENTA}└── update-spring-boot-keystore${RESET}"
  echo -e "    └── ${YELLOW}update-spring-boot-keystore.sh${RESET} ${WHITE}→ Aggiorna keystore Spring Boot${RESET}"
}

if [[ "$1" == "-t" || "$1" == "--tree" ]]; then
  print_tree
  exit 0
fi

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
  [Yy]*)
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
  *)
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
echo -e "${RED}█▀▄▀█${BLOOD_RED} ██   █▄▄▄▄ ${RED}█▀▄▀█${RESET} ${BLACK_PITCH}▄█${RED}    ▄▄▄▄▀${BLACK_PITCH}    ▄▄▄▄▀ ██${BLACK_PITCH}"
sleep 0.05
echo -e "${DARK_RED}█ █ █${RED} █ █  █  4▀ ${DARK_RED}█ █ █${RED} ██${BLACK_PITCH} ▀▀▀${BLOOD_RED} █${BLACK_PITCH}    ▀▀▀ ${RED}█    █ █${BLOOD_RED}"
sleep 0.05
echo -e "${RED}█ ▄ █${BLOOD_RED} █▄▄█ █▀▀▌  █ ▄ █${BLACK_PITCH} ██${RED}     █${BLACK_PITCH}        █    █▄▄█${BLOOD_RED}"
sleep 0.05
echo -e "${DARK_RED}█   █${RED} █  █ █  █  █   █${BLACK_PITCH} ▐█${RED}    █${DARK_RED}        █     █  █${RESET}"
sleep 0.05
echo -e "   ${RED}█     █   █      █   ▐   ▀        ▀         █${RESET}"
sleep 0.05
echo -e "  ${BLOOD_RED}▀     █   ▀      ▀                          █${RESET}"
sleep 0.05
echo -e "       ${RED}▀                                     ▀${RESET}"
sleep 0.1
echo -e "       ${RED}                                    ${RESET}"
sleep 0.1
echo -e "       ${RED}▀                                     ▀${RESET}"
sleep 0.1

echo -e "       ${BLOOD_RED}▀                    
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⢀⣴⠟⠉⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣀⢀⣾⠿⠻⢶⣄⠀⠀⣠⣶⡿⠶⣄⣠⣾⣿⠗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⢻⣿⣿⡿⣿⠿⣿⡿⢼⣿⣿⡿⣿⣎⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⠉⠛⢛⣛⡉⠀⠀⠙⠛⠻⠛⠑⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣧⣤⣴⠿⠿⣷⣤⡤⠴⠖⠳⣄⣀⣹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣀⣟⠻⢦⣀⡀⠀⠀⠀⠀⣀⡈⠻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡿⠉⡇⠀⠀⠛⠛⠛⠋⠉⠉⠀⠀⠀⠹⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡟⠀⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⠈⠑⠪⠷⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣦⣼⠛⢦⣤⣄⡀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠢⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣠⠴⠲⠖⠛⠻⣿⡿⠛⠉⠉⠻⠷⣦⣽⠿⠿⠒⠚⠋⠉⠁⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣾⠛⠁⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀
⠀⠀⠀⠀⣰⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣑⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀
⠀⠀⠀⣰⣿⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣧⣄⠀⠀⠀⠀⠀⠀⢳⡀⠀
⠀⠀⠀⣿⡾⢿⣀⢀⣀⣦⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⣫⣿⡿⠟⠻⠶⠀⠀⠀⠀⠀⢳⠀
⠀⠀⢀⣿⣧⡾⣿⣿⣿⣿⣿⡷⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⢀⡴⢿⣿⣧⠀⡀⠀⢀⣀⣀⢒⣤⣶⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇
⠀⠀⡾⠁⠙⣿⡈⠉⠙⣿⣿⣷⣬⡛⢿⣶⣶⣴⣶⣶⣶⣤⣤⠤⠾⣿⣿⣿⡿⠿⣿⠿⢿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇
⠀⣸⠃⠀⠀⢸⠃⠀⠀⢸⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⠟⡉⠀⠀⠀⠈⠙⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇
⠀⣿⠀⠀⢀⡏⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⠿⠿⠛⠛⠉⠁⠀⠀⠀⠀⠀⠉⠠⠿⠟⠻⠟⠋⠉⢿⣿⣦⡀⢰⡀⠀⠀⠀⠀⠀⠀⠁
⢀⣿⡆⢀⡾⠀⠀⠀⠀⣾⠏⢿⣿⣿⣿⣯⣙⢷⡄⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣿⣻⢿⣷⣀⣷⣄⠀⠀⠀⠀⢸⠀
⢸⠃⠠⣼⠃⠀⠀⣠⣾⡟⠀⠈⢿⣿⡿⠿⣿⣿⡿⠿⠿⠿⠷⣄⠈⠿⠛⠻⠶⢶⣄⣀⣀⡠⠈⢛⡿⠃⠈⢿⣿⣿⡿⠀⠀⠀⠀⠀⡀
⠟⠀⠀⢻⣶⣶⣾⣿⡟⠁⠀⠀⢸⣿⢅⠀⠈⣿⡇⠀⠀⠀⠀⠀⣷⠂⠀⠀⠀⠀⠐⠋⠉⠉⠀⢸⠁⠀⠀⠀⢻⣿⠛⠀⠀⠀⠀⢀⠇
⠀⠀⠀⠀⠹⣿⣿⠋⠀⠀⠀⠀⢸⣧⠀⠰⡀⢸⣷⣤⣤⡄⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡆⠀⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⢼⡇
⠀⠀⠀⠀⠀⠙⢻⠄⠀⠀⠀⠀⣿⠉⠀⠀⠈⠓⢯⡉⠉⠉⢱⣶⠏⠙⠛⠚⠁⠀⠀⠀⠀⠀⣼⠇⠀⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀⡇
⠀⠀⠀⠀⠀⠀⠻⠄⠀⠀⠀⢀⣿⠀⢠⡄⠀⠀⠀⣁⠁⡀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⢀⣐⡟⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⢠⡇                   ${RESET}"
sleep 0.1

# 🖊️ Sottotitolo finale
echo -e "\n${CYAN}${BOLD}SCRIPT MARMITTA - powered by FATT E CAZZ TUOJ 😈${RESET}\n"
sleep 0.

# Scarica il file remoto temporaneamente
# TEMP_FILE=$(mktemp)
# curl -s -o "$TEMP_FILE" "$REMOTE_URL"

# if [ ! -f "$LOCAL_FILE" ]; then
#   echo -e "${RED}File locale non trovato!${NC}"
#   rm "$TEMP_FILE"
#   exit 1
# fi

# # Confronta i due file
# if diff "$LOCAL_FILE" "$TEMP_FILE" >/dev/null; then
#   echo -e "${GREEN}Marmitta è aggiornato all'ultima versione${NC}"
#   sleep 1
# else
#   echo -e "${YELLOW}Marmitta non aggiornato, esegui marmitta -u per aggiornare${NC}"
# fi

FILE_NAME="marmitta.sh"
SCRIPT_PATH="/usr/local/bin/marmitta"

# Controllo esistenza script installato
if [ ! -f "$SCRIPT_PATH" ]; then
  echo -e "${RED}❌ Script non trovato in $SCRIPT_PATH${NC}"
  exit 1
fi

# Calcolo SHA locale
LOCAL_SHA=$(git hash-object "$SCRIPT_PATH")

# SHA remoto da GitHub API
REMOTE_SHA=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "$REPO_API_URL/$FILE_NAME?ref=master" | jq -r .sha)

# Verifica errori
if [[ -z "$REMOTE_SHA" || "$REMOTE_SHA" == "null" ]]; then
  echo -e "${RED}❌ Errore nel recupero SHA remoto${NC}"
  exit 1
fi

# Se chiamato con -u => aggiorna
if [[ "$1" == "-u" ]]; then
  echo -e "${YELLOW}↻ Aggiornamento in corso...${NC}"
  curl -s -o "$SCRIPT_PATH" "$BASE_URL/$FILE_NAME"
  chmod +x "$SCRIPT_PATH"
  echo -e "${GREEN}✅ Marmitta aggiornato con successo!${NC}"
  exit 0
fi

# Confronto
if [ "$LOCAL_SHA" == "$REMOTE_SHA" ]; then
  echo -e "${GREEN}✅ Marmitta è aggiornato all'ultima versione${NC}"
else
  echo -e "${YELLOW}⚠️  Marmitta non aggiornato. Esegui 'marmitta -u' per aggiornare.${NC}"
fi

# Rimuovi il file temporaneo
# rm "$TEMP_FILE"

# 🗂️ Scegli cartella
while true; do
  echo -e "\n${MAGENTA}📁 Seleziona una cartella:${RESET}"
  echo -e "${CYAN}$(pwd)${RESET}"

  folders_json=$(curl -s "${AUTH_HEADER[@]}" "$REPO_API_URL")

  if echo "$folders_json" | grep -q 'API rate limit exceeded'; then
    echo -e "${RED}❌ API rate limit superato. Esporta GITHUB_TOKEN per aumentare il limite.${RESET}"
    echo -e "${CYAN}Esempio:${RESET} export GITHUB_TOKEN=ghp_tuoTokenQui"
    exit 1
  fi

  folders=$(echo "$folders_json" | jq -r '.[] | select(.type == "dir") | .name')
  selected_folder=$(
    echo -e "🔙 Torna indietro\n$folders" | fzf --height=20 --layout=reverse --border --prompt="📁 Cartella > " --ansi --color=fg:white,bg:black,hl:red,pointer:green,marker:yellow --color=fg:#d6de35,bg:#121212,hl:#5f87af --color=fg+:#00ffd9,bg+:#5c00e6,hl+:#5fd7ff --color=fg:#ff00aa,bg:#073a42,hl:#5f87af

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
  selected_script=$(echo -e "� Torna indietro\n$scripts" | fzf --height=15 --layout=reverse --border --prompt="📜 Script > " --ansi --color=fg:white,bg:#292929,hl:red,pointer:green,marker:yellow --color=fg:#d6de35,bg:#121212,hl:#5f87af)

  [[ -z "$selected_script" || "$selected_script" == "🔙 Torna indietro" ]] && continue

  echo -e "${GREEN}✅ Hai scelto script: $selected_script${RESET}"

  # 📡 Metodo di download
  downloader="curl -fsSL"
  URL_FULL="$BASE_URL/$selected_folder/$selected_script"
  echo "$URL_FULL" >~/.marmitta_last_script
  echo "💾 Salvato ultimo script: $URL_FULL"

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
        curl -fsSL "$URL_FULL" -o "$temp_script" || {
          echo -e "${RED}Errore nel download dello script.${RESET}"
          exit 1
        }
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
