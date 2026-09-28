#!/usr/bin/env python3
"""
build.py — Academic Document Builder for Prof. Muaaz Bhamjee
=============================================================
Builds all LaTeX documents in the repository.

  Document types
  ──────────────
  bib_cv   — CV: reads .bib files, injects publications into a
             template, then compiles to PDF.
  latex    — Plain LaTeX: compiles a .tex file directly to PDF
             with two passes for cross-references.

  Output locations
  ────────────────
  docs/PDFs  — tracked by Git; pushed to muaazbhamjee.github.io
               via the site/ submodule on make publish-site.
  site/PDFs  — copied into the github.io submodule automatically
               once it is initialised (make submodule-init).
  site/      — index.html is mirrored from the repo root on every
    index.html build, so the homepage and the PDFs stay in step.

Usage:
    python3 build.py              # build all documents
    python3 build.py cv           # CV only
    python3 build.py statement    # NITheCS statement only
    python3 build.py publications # publications list only (CV publications section)

Adding a new plain-LaTeX document:
    1. Add a .tex file to this directory.
    2. Add one entry to DOCUMENTS below (type 'latex').
    3. Run python3 build.py.

Workflow to update publications (CV):
    1. Add/edit an entry in the relevant .bib file.
    2. Run:  python3 build.py cv
    3. PDF lands in docs/ and site/ automatically.

Workflow to publish to GitHub Pages:
    make publish-site msg="Update CV March 2026"
"""

import re
import shutil
import subprocess
import sys
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DOCS_DIR   = os.path.join(SCRIPT_DIR, "docs")
SITE_DIR   = os.path.join(SCRIPT_DIR, "site")   # git submodule: muaazbhamjee.github.io
MAIN_TEX   = os.path.join(SCRIPT_DIR, "cv_bhamjee_main.tex")
OUT_TEX    = os.path.join(SCRIPT_DIR, "cv_bhamjee.tex")
INDEX_HTML = os.path.join(SCRIPT_DIR, "index.html")   # homepage, mirrored into site/

# ── pdflatex location ─────────────────────────────────────────────────────────
# Override PDFLATEX_CMD here if auto-detection picks the wrong binary,
# or set the environment variable PDFLATEX before running:
#     PDFLATEX=/path/to/pdflatex python3 build.py
#
# Common Windows paths (accessed from WSL via /mnt/c/...):
#   TeX Live:  /mnt/c/texlive/2024/bin/windows/pdflatex.exe
#   MiKTeX:    /mnt/c/Users/<user>/AppData/Local/Programs/MiKTeX/miktex/bin/x64/pdflatex.exe


def _detect_pdflatex():
    """
    Return the pdflatex binary to use.

    Priority:
      1. PDFLATEX environment variable (set by user or Makefile)
      2. Windows TeX Live via WSL  (/mnt/c/texlive/<year>/bin/windows/)
      3. Windows MiKTeX via WSL    (/mnt/c/Users/<user>/AppData/Local/...)
      4. Plain 'pdflatex'          (native Linux/macOS install on PATH)
    """
    # Detect WSL by checking /proc/version for 'microsoft'
    try:
        with open('/proc/version') as f:
            is_wsl = 'microsoft' in f.read().lower()
    except OSError:
        is_wsl = False

    if is_wsl:
        # ── TeX Live on Windows ───────────────────────────────
        import glob
        texlive_pattern = '/mnt/c/texlive/*/bin/windows/pdflatex.exe'
        matches = sorted(glob.glob(texlive_pattern), reverse=True)  # newest year first
        if matches:
            print(f"  [WSL] Using Windows TeX Live: {matches[0]}")
            return matches[0]

        # ── MiKTeX on Windows ─────────────────────────────────
        # Walk common Windows user directories accessible via /mnt/c/Users/
        users_root = '/mnt/c/Users'
        if os.path.isdir(users_root):
            for user in os.listdir(users_root):
                candidate = (
                    f'/mnt/c/Users/{user}/AppData/Local/Programs/'
                    f'MiKTeX/miktex/bin/x64/pdflatex.exe'
                )
                if os.path.isfile(candidate):
                    print(f"  [WSL] Using Windows MiKTeX: {candidate}")
                    return candidate

        print("  [WSL] WARNING: No Windows LaTeX found under /mnt/c/. "
              "Set PDFLATEX=/path/to/pdflatex.exe or install LaTeX in WSL.")

    # Fallback: whatever is on PATH (native Linux or macOS)
    return 'pdflatex'


PDFLATEX_CMD = os.environ.get('PDFLATEX') or _detect_pdflatex()


# ── Document registry ─────────────────────────────────────────────────────────
# Add future documents here. Each entry is a dict with:
#   name     — short CLI name  (python3 build.py <name>)
#   type     — 'bib_cv' or 'latex'
#   tex      — path to the .tex source (for 'latex' type)
#   template — .tex template containing the publications placeholder
#              (for 'bib_cv' type; defaults to cv_bhamjee_main.tex)
#   out      — generated .tex path (for 'bib_cv' type; defaults to cv_bhamjee.tex)
#   label    — human-readable description for build output
DOCUMENTS = [
    {
        'name':  'cv',
        'type':  'bib_cv',
        'label': 'CV',
    },
    {
        'name':     'publications',
        'type':     'bib_cv',
        'template': os.path.join(SCRIPT_DIR, 'cv_bhamjee_publications_main.tex'),
        'out':      os.path.join(SCRIPT_DIR, 'cv_bhamjee_publications.tex'),
        'label':    'Publications list (CV publications section only)',
    },
    {
        'name':  'statement',
        'type':  'latex',
        'tex':   os.path.join(SCRIPT_DIR, 'nithecs_statement.tex'),
        'label': 'NITheCS Candidate Statement',
    },
    {
        'name':  'cv-abridged',
        'type':  'latex',
        'tex':   os.path.join(SCRIPT_DIR, 'cv_bhamjee_abridged.tex'),
        'label': 'Abridged CV (3-page)',
    },
]


# ── Shared LaTeX compiler ─────────────────────────────────────────────────────

def compile_latex(tex_path, label):
    """
    Compile tex_path twice (for cross-references).
    On success, copies the PDF to docs/ as well.
    Returns True on success.
    """
    pdf_path  = tex_path.replace('.tex', '.pdf')
    pdf_name  = os.path.basename(pdf_path)
    docs_copy = os.path.join(DOCS_DIR, pdf_name)

    cmd = [PDFLATEX_CMD, '-interaction=nonstopmode',
           '-output-directory', SCRIPT_DIR, tex_path]

    print(f"  Compiling {label} (pass 1)...")
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=SCRIPT_DIR)
    errors = [l for l in r.stdout.splitlines() if l.startswith('!')]
    if errors:
        print(f"  LaTeX errors in {label}:")
        for e in errors:
            print(f"    {e}")
        return False

    print(f"  Compiling {label} (pass 2)...")
    subprocess.run(cmd, capture_output=True, cwd=SCRIPT_DIR)

    if not os.path.exists(pdf_path):
        print(f"  WARNING: PDF not produced for {label}")
        return False

    size = os.path.getsize(pdf_path) // 1024
    print(f"  ✓  {pdf_name}  ({size} KB)")

    # Move to docs/ (no duplicate at root)
    os.makedirs(DOCS_DIR, exist_ok=True)
    shutil.move(pdf_path, docs_copy)
    print(f"  ✓  docs/{pdf_name}")

    # Copy into site/ only once it is a real submodule — filling a bare
    # site/ directory would block `git submodule update --init` later
    if os.path.exists(os.path.join(SITE_DIR, ".git")):
        site_copy = os.path.join(SITE_DIR, pdf_name)
        shutil.copy2(docs_copy, site_copy)
        print(f"  ✓  site/{pdf_name}  (github.io copy)")

    return True


# ── BibTeX parser ─────────────────────────────────────────────────────────────

def parse_bib_file(filepath):
    """Return list of dicts, one per BibTeX entry (brace-depth aware)."""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    content = re.sub(r'(?m)^\s*%.*$', '', content)   # strip comment lines
    entries = []
    i = 0
    while True:
        m = re.search(r'@(\w+)\s*\{', content[i:])
        if not m:
            break
        typ = m.group(1).lower()
        start = i + m.end()
        depth, j = 1, start
        while j < len(content) and depth > 0:
            if content[j] == '{':
                depth += 1
            elif content[j] == '}':
                depth -= 1
            j += 1
        body = content[start:j - 1]
        i = j
        if typ in ('comment', 'string', 'preamble'):
            continue
        key, _, rest = body.partition(',')
        entry = {'type': typ, 'key': key.strip()}
        k = 0
        while True:
            fm = re.search(r'(\w+)\s*=\s*', rest[k:])
            if not fm:
                break
            name = fm.group(1).lower()
            pos = k + fm.end()
            if pos < len(rest) and rest[pos] == '{':
                d, q = 1, pos + 1
                while q < len(rest) and d > 0:
                    if rest[q] == '{':
                        d += 1
                    elif rest[q] == '}':
                        d -= 1
                    q += 1
                val, k = rest[pos + 1:q - 1], q
            elif pos < len(rest) and rest[pos] == '"':
                q = rest.find('"', pos + 1)
                val, k = rest[pos + 1:q], q + 1
            else:
                q = rest.find(',', pos)
                q = len(rest) if q < 0 else q
                val, k = rest[pos:q], q
            entry[name] = ' '.join(val.split())
        entries.append(entry)
    return entries


def load_all_bibs():
    bib_files = {
        'journals_non_atlas': 'journals_non_atlas.bib',
        'journals_atlas':     'journals_atlas.bib',
        'conferences':        'conferences.bib',
        'patents':            'patents.bib',
        'bookchapters':       'bookchapters.bib',
        'other_scholarly':    'other_scholarly.bib',
    }
    data = {}
    for name, filename in bib_files.items():
        path = os.path.join(SCRIPT_DIR, filename)
        if os.path.exists(path):
            data[name] = parse_bib_file(path)
            print(f"  Loaded {len(data[name]):3d} entries from {filename}")
        else:
            print(f"  WARNING: {filename} not found — skipping")
            data[name] = []
    return data


# ── Field helpers ─────────────────────────────────────────────────────────────

def clean(text):
    if not text:
        return ''
    text = re.sub(r'\{\{(.+?)\}\}', r'\1', text)
    return text.strip()

def get(entry, *fields, default=''):
    for f in fields:
        v = clean(entry.get(f, ''))
        if v:
            return v
    return default

def sort_year(entry):
    try:
        return int(entry.get('year', '0'))
    except ValueError:
        return 0


# ── LaTeX renderers ───────────────────────────────────────────────────────────

def render_non_atlas_journal(e):
    authors  = get(e, 'author')
    title    = get(e, 'title')
    journal  = get(e, 'journal')
    volume   = get(e, 'volume')
    number   = get(e, 'number')
    pages    = get(e, 'pages')
    year     = get(e, 'year')
    doi      = get(e, 'doi')
    note     = get(e, 'note')
    vol_str  = f"vol.~{volume}" if volume else ''
    num_str  = f"No.~{number}" if number else ''
    pag_str  = f"pp.~{pages}" if pages else ''
    detail   = ', '.join(x for x in [vol_str, num_str, pag_str, year] if x)
    doi_str  = f" \\href{{https://doi.org/{doi}}}{{DOI}}" if doi else ''
    note_str = f" {note}." if note else ''
    return (
        f"  \\item {authors}, ``{title}'', "
        f"\\textit{{{journal}}}, {detail}.{note_str}{doi_str}\n"
    )

def render_atlas_journal(e):
    title   = get(e, 'title')
    journal = get(e, 'journal')
    volume  = get(e, 'volume')
    number  = get(e, 'number')
    pages   = get(e, 'pages')
    year    = get(e, 'year')
    doi     = get(e, 'doi')
    vol_str = f"vol.~{volume}" if volume else ''
    num_str = f"No.~{number}" if number else ''
    pag_str = f"pp.~{pages}" if pages else ''
    detail  = ', '.join(x for x in [vol_str, num_str, pag_str, year] if x)
    doi_str = f" \\href{{https://doi.org/{doi}}}{{DOI}}" if doi else ''
    return (
        f"  \\item {{ATLAS Collaboration}}, ``{title}'', "
        f"\\textit{{{journal}}}, {detail}.{doi_str}\n"
    )

def render_conference(e):
    authors   = get(e, 'author')
    title     = get(e, 'title')
    booktitle = get(e, 'booktitle')
    address   = get(e, 'address')
    pages     = get(e, 'pages')
    year      = get(e, 'year')
    doi       = get(e, 'doi')
    url       = get(e, 'url')
    addr_str  = f", {address}" if address else ''
    pages_str = f", pp.~{pages}" if pages else ''
    doi_str   = (f" \\href{{https://doi.org/{doi}}}{{DOI}}" if doi
                 else (f" \\href{{{url}}}{{Link}}" if url else ''))
    return (
        f"  \\item {authors}, ``{title}'', "
        f"\\textit{{{booktitle}}}{addr_str}{pages_str}, {year}.{doi_str}\n"
    )

def render_patent(e):
    authors = get(e, 'author')
    title   = get(e, 'title')
    note    = get(e, 'note')
    url     = get(e, 'url')
    url_str = f"\n  \\href{{{url}}}{{Link}}" if url else ''
    return (
        f"  \\item \\textbf{{``{title}''}}\\\\[2pt]\n"
        f"  Inventors: {authors}.\\\\\n"
        f"  {note}{url_str}\n"
    )

def render_bookchapter(e):
    authors   = get(e, 'author')
    title     = get(e, 'title')
    booktitle = get(e, 'booktitle')
    editor    = get(e, 'editor')
    series    = get(e, 'series')
    volume    = get(e, 'volume')
    pages     = get(e, 'pages')
    publisher = get(e, 'publisher')
    address   = get(e, 'address')
    year      = get(e, 'year')
    doi       = get(e, 'doi')
    ed_str   = f", eds. {editor}" if editor else ''
    ser_str  = f", {series}" if series else ''
    vol_str  = f" vol.~{volume}" if volume else ''
    pag_str  = f", pp.~{pages}" if pages else ''
    pub_str  = f", {publisher}" if publisher else ''
    addr_str = f", {address}" if address else ''
    doi_str  = f" \\href{{https://doi.org/{doi}}}{{DOI}}" if doi else ''
    return (
        f"  \\item {authors}, ``{title}'', in \\textit{{{booktitle}}}"
        f"{ed_str}{ser_str}{vol_str}{pag_str}{pub_str}{addr_str}, {year}.{doi_str}\n"
    )

def render_other(e):
    authors = get(e, 'author')
    title   = get(e, 'title')
    how     = get(e, 'howpublished')
    year    = get(e, 'year')
    url     = get(e, 'url')
    url_str = f" \\href{{{url}}}{{Link}}" if url else ''
    return (
        f"  \\item {authors}, ``{title}'',\n"
        f"  {how}, {year}.{url_str}\n"
    )


# ── Section builders ──────────────────────────────────────────────────────────

def build_non_atlas_journals(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = ["\\subsection*{Non-ATLAS Journal Papers}\n", "\\begin{publist}\n"]
    for e in entries:
        lines.append(render_non_atlas_journal(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)

def build_atlas_journals(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = [
        "\\subsection*{ATLAS/CERN Collaboration Papers}\n"
        "\\textit{Note: Papers on which Bhamjee is a contributing author, "
        "as indexed on Google Scholar.}\n\n",
        "\\begin{publist}\n",
    ]
    for e in entries:
        lines.append(render_atlas_journal(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)

def build_conferences(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = ["\\subsection*{Published}\n", "\\begin{publist}\n"]
    for e in entries:
        lines.append(render_conference(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)

def build_patents(entries):
    lines = ["\\begin{publist}\n"]
    for e in sorted(entries, key=sort_year, reverse=True):
        lines.append(render_patent(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)

def build_bookchapters(entries):
    lines = ["\\begin{publist}\n"]
    for e in sorted(entries, key=sort_year, reverse=True):
        lines.append(render_bookchapter(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)

def build_other_scholarly(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = ["\\begin{publist}\n"]
    for e in entries:
        lines.append(render_other(e))
    lines.append("\\end{publist}\n")
    return ''.join(lines)


# ── Document builders ─────────────────────────────────────────────────────────

PLACEHOLDER = "%%AUTO-GENERATED-PUBLICATIONS%%"

def build_bib_cv(doc):
    """Inject publications into the CV template and compile."""
    print(f"\n=== Building: {doc['label']} ===")
    print("Loading .bib files...")
    data = load_all_bibs()

    print("Generating publication sections...")
    pub_block = '\n'.join([
        "% ---- AUTO-GENERATED: do not edit below this line ----",
        "",
        "\\section{Journal Publications}",
        "\\textit{(Accredited Journals. {ATLAS}/CERN collaboration papers listed below as "
        "indexed on Google Scholar.)}",
        "",
        build_non_atlas_journals(data['journals_non_atlas']),
        build_atlas_journals(data['journals_atlas']),
        "",
        "% ---- END AUTO-GENERATED journals ----",
        "",
        "\\section{Patents}",
        build_patents(data['patents']),
        "",
        "\\section{Book Chapters}",
        build_bookchapters(data['bookchapters']),
        "",
        "\\section{Conference Publications}",
        build_conferences(data['conferences']),
        "",
        "\\section{Other Scholarly Contributions}",
        build_other_scholarly(data['other_scholarly']),
        "",
        "% ---- END AUTO-GENERATED publications ----",
    ])

    main_tex = doc.get('template', MAIN_TEX)
    out_tex  = doc.get('out', OUT_TEX)

    print(f"Reading template: {main_tex}")
    with open(main_tex, encoding="utf-8") as f:
        template = f.read()

    if PLACEHOLDER not in template:
        print(f"ERROR: Placeholder '{PLACEHOLDER}' not found in {main_tex}")
        return False

    with open(out_tex, 'w', encoding="utf-8") as f:
        f.write(template.replace(PLACEHOLDER, pub_block))

    return compile_latex(out_tex, doc['label'])


def build_latex(doc):
    """Compile a plain LaTeX document."""
    print(f"\n=== Building: {doc['label']} ===")
    tex = doc.get('tex')
    if not tex or not os.path.exists(tex):
        print(f"  ERROR: source file not found: {tex}")
        return False
    return compile_latex(tex, doc['label'])


# ── Entry point ───────────────────────────────────────────────────────────────

def copy_index_html():
    """Mirror the root index.html into the github.io submodule.

    Runs on every build regardless of target: the homepage carries the same
    metrics as the PDFs, so it must not lag behind them.
    """
    if not os.path.exists(INDEX_HTML):
        return
    if not os.path.exists(os.path.join(SITE_DIR, ".git")):
        return

    site_copy = os.path.join(SITE_DIR, "index.html")
    print("\n=== Syncing: index.html ===")
    shutil.copy2(INDEX_HTML, site_copy)
    print("  ✓  site/index.html  (github.io copy)")


def build(targets):
    """Build each document whose name is in targets (or all if targets is empty)."""
    registry = {d['name']: d for d in DOCUMENTS}

    for t in targets:
        if t not in registry:
            valid = ', '.join(registry)
            print(f"ERROR: unknown target '{t}'. Valid targets: {valid}")
            sys.exit(1)

    docs_to_build = [registry[t] for t in targets] if targets else DOCUMENTS

    results = {}
    for doc in docs_to_build:
        if doc['type'] == 'bib_cv':
            results[doc['name']] = build_bib_cv(doc)
        elif doc['type'] == 'latex':
            results[doc['name']] = build_latex(doc)
        else:
            print(f"  ERROR: unknown document type '{doc['type']}'")
            results[doc['name']] = False

    copy_index_html()

    # Summary
    print("\n" + "=" * 40)
    all_ok = True
    for name, ok in results.items():
        status = "✓" if ok else "✗ FAILED"
        print(f"  {status}  {name}")
        if not ok:
            all_ok = False
    print("=" * 40)
    if not all_ok:
        sys.exit(1)


if __name__ == '__main__':
    targets = sys.argv[1:]
    build(targets)
