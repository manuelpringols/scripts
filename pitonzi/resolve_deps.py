import sys
import re

# Moduli builtin C e standard library (approssimazione)
STANDARD_LIBS = {
    'sys', 'os', 're', 'math', 'socket', 'datetime', 'json', 'logging',
    'subprocess', 'shutil', 'threading', 'itertools', 'functools',
    'collections', 'pathlib', 'argparse', 'typing', 'http', 'urllib',
    'time', 'random', 'string', 'enum', 'traceback', 'platform'
}

# Include i moduli builtin di Python (C built-in modules)
STANDARD_LIBS.update(sys.builtin_module_names)

# Mapping da modulo → nome su pip (se diversi)
CUSTOM_MAP = {
    # Imaging
    'PIL': 'Pillow',

    # Networking & Security
    'impacket': 'impacket',
    'smb': 'impacket',  # alias in impacket
    'netaddr': 'netaddr',
    'Crypto': 'pycryptodome',  # pycrypto è deprecato, pycryptodome è fork

    # Data Science / ML
    'sklearn': 'scikit-learn',
    'cv2': 'opencv-python',
    'bs4': 'beautifulsoup4',
    'lxml': 'lxml',  # coincidenti ma spesso usato
    'matplotlib': 'matplotlib',
    'pandas': 'pandas',
    'numpy': 'numpy',
    'tensorflow': 'tensorflow',
    'torch': 'torch',

    # Web / HTTP
    'requests': 'requests',
    'flask': 'flask',
    'django': 'django',
    'werkzeug': 'werkzeug',

    # Database
    'psycopg2': 'psycopg2-binary',
    'MySQLdb': 'mysqlclient',

    # Parsing
    'yaml': 'PyYAML',
    'jsonschema': 'jsonschema',

    # Others
    'dateutil': 'python-dateutil',
    'cryptography': 'cryptography',
    'pytest': 'pytest',
    'selenium': 'selenium',
    'paramiko': 'paramiko',
    'sqlalchemy': 'SQLAlchemy',

    # Misc
    'Pygments': 'Pygments',
    'pytest_mock': 'pytest-mock',
    'pytest_cov': 'pytest-cov',
}

def extract_imports(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    modules = set()

    for line in content.splitlines():
        line = line.strip()
        if line.startswith('import '):
            # Esempio: import numpy as np, os
            parts = line[7:].split(',')
            for part in parts:
                mod = part.strip().split(' ')[0]  # prendo solo il nome del modulo
                modules.add(mod)
        elif line.startswith('from '):
            # Esempio: from requests.models import Response
            match = re.match(r'^from\s+([a-zA-Z0-9_\.]+)', line)
            if match:
                mod = match.group(1).split('.')[0]
                modules.add(mod)

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
    if deps:
        print(' '.join(sorted(deps)))
    else:
        print("Nessuna dipendenza esterna trovata.")
