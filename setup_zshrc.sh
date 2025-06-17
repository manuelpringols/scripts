#!/bin/bash

set -e

# 1. Installa zsh (usa apt, ma puo rilevare e  cambiare per pacchetti tipo yum/pacman)
echo "🔧 Installing zsh..."

if ! command -v zsh &> /dev/null; then
    # Rileva la distribuzione
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=$ID
    else
        echo "❌ Impossibile determinare la distribuzione."
        exit 1
    fi

    case "$distro" in
        ubuntu|debian)
            sudo apt update && sudo apt install -y zsh
            ;;
        fedora)
            sudo dnf install -y zsh
            ;;
        centos|rhel)
            sudo yum install -y zsh
            ;;
        arch)
            sudo pacman -Sy --noconfirm zsh
            ;;
        opensuse*|suse)
            sudo zypper install -y zsh
            ;;
	raspbian)
     	    sudo apt install -y zsh
	    ;;
        *)
            echo "❌ Distribuzione non supportata: $distro"
            exit 1
            ;;
    esac
else
    echo "✅ zsh is already installed."
fi

# 2. Imposta zsh come shell predefinita
echo "🔧 Setting zsh as default shell..."
chsh -s "$(which zsh)"

# 3. Installa Oh My Zsh
echo "✨ Installing Oh My Zsh..."
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Installa plugin zsh-syntax-highlighting
echo "🔧 Installing zsh-syntax-highlighting plugin..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 5. Installa plugin zsh-autosuggestions
echo "🔧 Installing zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# 6. Sovrascrive ~/.zshrc con il file fornito
echo "📄 Replacing ~/.zshrc..."
cp ./spinal ~/.zshrc

echo "✅ Setup completato. Avvia una nuova sessione zsh o esegui 'zsh' ora."
