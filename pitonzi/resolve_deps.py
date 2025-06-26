import sys
import re

# Moduli della standard library Python 3.10+ (approssimazione)
STANDARD_LIBS = {
    'sys', 'os', 're', 'math', 'socket', 'datetime', 'json', 'logging',
    'subprocess', 'shutil', 'threading', 'itertools', 'functools',
    'collections', 'pathlib', 'argparse', 'typing', 'http', 'urllib',
    'time', 'random', 'string', 'enum', 'traceback'
}

# Mapping da modulo → nome su pip
CUSTOM_MAP = {
    'impacket': 'impacket',
    'smb': 'impacket',
    'netaddr': 'netaddr'
}

def extract_imports(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    modules = set()

    for line in content.splitlines():
        line = line.strip()
        if line.startswith('import '):
            parts = line.split()
            if len(parts) > 1:
                modules.update(parts[1].split(','))
        elif line.startswith('from '):
            match = re.match(r'^from\s+([a-zA-Z0-9_\.]+)', line)
            if match:
                modules.add(match.group(1).split('.')[0])

    # Pulisce e filtra
    cleaned = set()
    for m in modules:
        mod = m.strip()
        if mod and mod not in STANDARD_LIBS:
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
    print(' '.join(deps))
