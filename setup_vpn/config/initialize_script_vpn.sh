#!/bin/bash

echo "==============================="
echo "🔧 Inizializzazione VPN Script"
echo "==============================="

# Spostati nella directory dove si trova lo script (es: /tmp/config)
cd "$(dirname "$0")" || {
    echo "❌ Impossibile accedere alla directory dello script."
    exit 1
}

# Step 1: Crea ambiente virtuale
echo "➡️  Creazione ambiente virtuale (venv)..."
python3 -m venv venv || {
    echo "❌ Errore nella creazione dell'ambiente virtuale."
    exit 1
}

# Step 2: Attivazione ambiente virtuale
echo "➡️  Attivazione dell'ambiente virtuale..."
source venv/bin/activate || {
    echo "❌ Impossibile attivare l'ambiente virtuale."
    exit 1
}

# Step 3: Installazione dei pacchetti da requirements.txt
echo "➡️  Installazione delle dipendenze da requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt || {
    echo "❌ Errore durante l'installazione delle dipendenze."
    deactivate
    exit 1
}

# Step 4: Verifica se tkinter è disponibile
echo "➡️  Verifica della presenza del modulo tkinter..."
python -c "import tkinter" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️  Il modulo tkinter non è disponibile nel tuo Python."
    echo "   Su Arch Linux puoi installarlo con:"
    echo "   👉 sudo pacman -S tk"
    echo "❌ Fermando lo script. Installa 'tk' e riprova."
    deactivate
    exit 1
else
    echo "✅ tkinter disponibile."
fi

# Step 5: Esecuzione dello script Python
echo "➡️  Esecuzione dello script: script_vpn.py"
python script_vpn.py

