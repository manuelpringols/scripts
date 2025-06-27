import sys
import re
import importlib.util
import sysconfig
import os

# Mapping da modulo → nome su pip (se diversi)
CUSTOM_MAP = {
    'impacket': 'impacket',
    'smb': 'impacket',
    'netaddr': 'netaddr',
    # puoi aggiungere altri qui...
}

def is_builtin_or_stdlib(mod_name):
    # controlla built-in moduli Python (C built-in)
    if mod_name in sys.builtin_module_names:
        return True

    try:
        spec = importlib.util.find_spec(mod_name)
        if spec is None:
            # modulo non trovato → potrebbe essere custom o locale, quindi no
            return False
        origin = spec.origin
        if origin is None:
            # moduli built-in senza origine file (tipo 'sys')
            return True

        # percorso standard Python stdlib (es. /usr/lib/python3.10)
        stdlib_path = sysconfig.get_paths()['stdlib']

        # verifica se il modulo si trova dentro la cartella stdlib
        # (se no, probabilmente è installato con pip o locale)
        return os.path.commonpath([origin, stdlib_path]) == stdlib_path
    except ModuleNotFoundError:
        return False

def extract_imports(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    modules = set()

    for line in content.splitlines():
        line = line.strip()
        if line.startswith('import '):
            # esempio: import numpy as np, os
            parts = line[7:].split(',')
            for part in parts:
                mod = part.strip().split(' ')[0]
                modules.add(mod)
        elif line.startswith('from '):
            # esempio: from requests.models import Response
            match = re.match(r'^from\s+([a-zA-Z0-9_\.]+)', line)
            if match:
                mod = match.group(1).split('.')[0]
                modules.add(mod)

    # pulizia e filtro: ignora built-in e stdlib, applica CUSTOM_MAP
    cleaned = set()
    for m in modules:
        mod = m.strip()
        if mod:
            if is_builtin_or_stdlib(mod):
                # modulo built-in o standard library → skip
                continue
            if mod in CUSTOM_MAP:
                cleaned.add(CUSTOM_MAP[mod])
            else:
                cleaned.add(mod)

    return cleaned

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: resolve_deps.py <script.py>")
        sys.exit(1)

    deps = extract_imports(sys.argv[1])
    if deps:
        print(' '.join(sorted(deps)))
    else:
        print("Nessuna dipendenza esterna trovata.")
