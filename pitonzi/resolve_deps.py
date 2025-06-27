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
    import importlib.util, sysconfig, os
    if mod_name in sys.builtin_module_names:
        print(f"{mod_name} è built-in (sys.builtin_module_names)")
        return True

    try:
        spec = importlib.util.find_spec(mod_name)
        if spec is None:
            print(f"{mod_name} spec is None → non built-in")
            return False
        origin = spec.origin
        print(f"{mod_name} origin: {origin}")
        if origin is None or origin == 'built-in':
            print(f"{mod_name} è built-in o namespace package senza origine file")
            return True

        origin = os.path.abspath(origin)
        stdlib_path = os.path.abspath(sysconfig.get_paths()['stdlib'])
        is_std = os.path.commonpath([origin, stdlib_path]) == stdlib_path
        print(f"{mod_name} is stdlib? {is_std}")
        return is_std
    except ModuleNotFoundError:
        print(f"{mod_name} non trovato")
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
    for m in modules:
        mod = m.strip()
    if mod and not is_builtin_or_stdlib(mod):
        if mod in CUSTOM_MAP:
            cleaned.add(CUSTOM_MAP[mod])
        else:
            cleaned.add(mod)
    else:
        print(f"Escludo {mod} perché built-in o stdlib")

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
