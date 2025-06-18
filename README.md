# scripts

🚀 **Script Selector**  
Uno script bash interattivo per esplorare, scaricare ed eseguire facilmente gli script presenti in questo repository GitHub, con supporto per la selezione tramite `fzf`.

---

## Cosa fa?

- Naviga tra le cartelle del repository
- Seleziona uno script `.sh` da eseguire direttamente da remoto
- Supporta l’autenticazione tramite token GitHub per aumentare il limite di richieste API
- Permette di inserire argomenti per gli script
- Include la funzione "torna indietro" per una navigazione semplice e fluida

---

## Scaricare uno script singolo

Per scaricare e salvare localmente lo script `marmitta.sh` presente nella cartella `marmitta`, usa il seguente comando:

```bash
curl -fsSL https://raw.githubusercontent.com/manuelpringols/scripts/master/marmitta/marmitta.sh -o marmitta.sh
