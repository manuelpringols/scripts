#!/bin/bash

set -e

# Funzione spinner
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    echo -n " "
    while ps -p $pid &> /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

echo "🔧 Installing zsh..."

if ! command -v zsh &> /dev/null; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=$ID
    else
        echo "❌ Impossibile determinare la distribuzione."
        exit 1
    fi

    case "$distro" in
        ubuntu|debian|kali)
            (sudo apt update && sudo apt install -y zsh) & spinner
            ;;
        fedora)
            (sudo dnf install -y zsh) & spinner
            ;;
        centos|rhel)
            (sudo yum install -y zsh) & spinner
            ;;
        arch)
            (sudo pacman -Sy --noconfirm zsh) & spinner
            ;;
        opensuse*|suse)
            (sudo zypper install -y zsh) & spinner
            ;;
        raspbian)
            (sudo apt install -y zsh) & spinner
            ;;
        *)
            echo "❌ Distribuzione non supportata: $distro"
            exit 1
            ;;
    esac
else
    echo "✅ zsh is already installed."
fi

echo "🔧 Setting zsh as default shell..."
(chsh -s "$(which zsh)") & spinner

echo "✨ Installing Oh My Zsh..."
export RUNZSH=no
export KEEP_ZSHRC=yes
(sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)") & spinner

echo "🔧 Installing zsh-syntax-highlighting plugin..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting") & spinner

echo "🔧 Installing zsh-autosuggestions plugin..."
(git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions") & spinner

SCRIPTS_DIR="$HOME/.manuel_scripts"
if [ -d "$SCRIPTS_DIR" ]; then
    echo "📁 Directory $SCRIPTS_DIR già presente. Rimuovo e riscarico..."
    (rm -rf "$SCRIPTS_DIR") & spinner
fi

echo "📦 Cloning setup files..."
(git clone https://github.com/manuelpringols/scripts.git "$SCRIPTS_DIR") & spinner

echo "📄 Replacing ~/.zshrc with spinal..."
(cp "$SCRIPTS_DIR/setup_zshrc/spinal" ~/.zshrc) & spinner

echo "✅ Setup completato. Avvia una nuova sessione zsh o esegui 'zsh' ora."
