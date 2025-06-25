#!/bin/bash

# Colori terminale
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # Nessun colore

echo -e "${CYAN}🧪 Configurazione automatica di WezTerm...${NC}"

CONFIG_PATH="$HOME/.wezterm.lua"
BACKGROUND_DIR="$HOME/.config/wezterm/backgrounds"
BACKGROUND_IMG="$BACKGROUND_DIR/wez"

# Verifica se il file esiste già
if [ -f "$CONFIG_PATH" ]; then
    echo -e "${YELLOW}⚠️ Il file ${CONFIG_PATH} esiste già.${NC}"
    read -p "Vuoi sovrascriverlo? [s/N] " answer
    if [[ "$answer" != "s" && "$answer" != "S" ]]; then
        echo -e "${RED}❌ Operazione annullata.${NC}"
        exit 1
    fi
fi

# Chiedi se l'utente vuole usare un'immagine di sfondo
read -p "Vuoi usare un'immagine di sfondo personalizzata? [s/N] " bg_answer
use_bg="false"

if [[ "$bg_answer" == "s" || "$bg_answer" == "S" ]]; then
    use_bg="true"
    echo -e "${GREEN}📁 Salva la tua immagine nel seguente percorso:${NC}"
    echo -e "  ${YELLOW}$BACKGROUND_IMG${NC}"
    echo -e "${CYAN}Assicurati che il nome dell'immagine sia esattamente: ${YELLOW}wez${NC}"
    mkdir -p "$BACKGROUND_DIR"
fi

# Genera il contenuto del file
cat > "$CONFIG_PATH" <<EOF
local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Noto Sans Mono",
    "Symbols Nerd Font Mono",
  }),
  font_size = 12.0,

  -- Aspetto generale
  color_scheme = "Catppuccin Mocha",
  enable_tab_bar = false,
  use_fancy_tab_bar = false,

  window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  },

  freetype_load_target = "Light",
EOF

# Aggiunge sezione background se richiesto
if [[ "$use_bg" == "true" ]]; then
cat >> "$CONFIG_PATH" <<'EOF'

  background = {
    {
      source = {
        File = os.getenv("HOME") .. "/.config/wezterm/backgrounds/wez",
      },
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
      vertical_align = "Middle",
      horizontal_align = "Center",
      hsb = {
        brightness = 0.12,
      },
    },
  },
EOF
fi

# Chiude il file Lua
echo "}" >> "$CONFIG_PATH"

echo -e "${GREEN}✅ Configurazione completata!${NC}"
echo -e "${CYAN}➡️  Riavvia WezTerm per vedere i cambiamenti.${NC}"
