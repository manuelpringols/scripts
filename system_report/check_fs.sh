#!/bin/bash

# Directory da controllare
DIRS_TO_CHECK=(
    "/var/log"
    "/var/tmp"
    "/tmp"
    "/var/cache"
    "/home"
    "/root"
    "/var/lib"
)

echo "Inizio analisi dei file più pesanti nelle directory predefinite..."

for DIR in "${DIRS_TO_CHECK[@]}"; do
    if [ -d "$DIR" ]; then
        echo ""
        echo "Analisi in: $DIR"
        # Cerca i 20 file più grandi sopra i 100MB
        find "$DIR" -type f -size +100M -exec du -h {} + 2>/dev/null | sort -hr | head -n 20
    else
        echo "La directory $DIR non esiste, salto..."
    fi
done

echo ""
echo "Analisi completata. Valuta se puoi rimuovere qualche file."
