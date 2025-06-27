#!/usr/bin/env python3

import sys
import re
import importlib.util
import sysconfig
import os

# Mapping modulo → nome pip (se diversi)
CUSTOM_MAP = {
    'impacket': 'impacket',
    'smb': 'impacket',
    'netaddr': 'netaddr',
    'PIL': 'Pillow',
}

import sys
import os
import importlib.util
import sysconfig
import logging

logging.basicConfig(level=logging.WARNING)

def is_builtin_or_stdlib(mod_name):
    try:
        # 1. Moduli completamente built-in
        if mod_name in sys.builtin_module_names:
            return True

        # 2. Prendi lo "spec" del modulo
        spec = importlib.util.find_spec(mod_name)
        if spec is None:
            return False

        # 3. Se è built-in nel senso che non ha file (C extensions, ecc.)
        if spec.origin in (None, 'built-in', 'frozen'):
            return True

        origin = os.path.realpath(spec.origin)

        # 4. Directory della standard library
        stdlib_paths = [
            os.path.realpath(sysconfig.get_paths()['stdlib']),
            os.path.realpath(sysconfig.get_paths().get('platstdlib', ''))
        ]

        # 5. Escludi moduli di terze parti come quelli in site-packages
        if any(part in origin for part in ('site-packages', 'dist-packages')):
            return False

        # 6. Controlla se il modulo è nella stdlib
        return any(origin.startswith(stdlib_path) for stdlib_path in stdlib_paths)

    except Exception as e:
        logging.warning(f"Errore nel controllo del modulo '{mod_name}': {e}")
        return False


def extract_imports(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    modules = set()

    for line in content.splitlines():
        line = line.strip()
        if line.startswith('import '):
            parts = line[7:].split(',')
            for part in parts:
                mod = part.strip().split(' ')[0]
                modules.add(mod)
        elif line.startswith('from '):
            match = re.match(r'^from\s+([a-zA-Z0-9_\.]+)', line)
            if match:
                mod = match.group(1).split('.')[0]
                modules.add(mod)

    cleaned = set()
    for mod in modules:
        mod = mod.strip()
        if mod and not is_builtin_or_stdlib(mod):
            cleaned.add(CUSTOM_MAP.get(mod, mod))

    return cleaned

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: resolve_deps.py <script.py>", file=sys.stderr)
        sys.exit(1)

    deps = extract_imports(sys.argv[1])
    if deps:
        print(' '.join(sorted(deps)))  # solo i pacchetti
        # print("mario maria mario", file=sys.stderr)  # se vuoi debug
    else:
        print("Nessuna dipendenza esterna trovata. xD", file=sys.stderr)