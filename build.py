#!/usr/bin/env python3
"""
build.py — CV Publication Builder for Prof. Muaaz Bhamjee
==========================================================
Reads the .bib files and regenerates the publications section
of the main CV LaTeX file, then compiles the PDF.

Usage:
    python3 build.py

Requirements:
    - Python 3.6+
    - pdflatex (for compilation)
    - All .bib files in the same directory as this script
    - cv_bhamjee_main.tex in the same directory

Workflow to update the CV:
    1. Add/edit entries in the relevant .bib file
    2. Run:  python3 build.py
    3. Find updated PDF at:  cv_bhamjee.pdf
"""

import re
import subprocess
import sys
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
MAIN_TEX   = os.path.join(SCRIPT_DIR, "cv_bhamjee_main.tex")
OUT_TEX    = os.path.join(SCRIPT_DIR, "cv_bhamjee.tex")

# ── BibTeX parser ──────────────────────────────────────────────────────────────

def parse_bib_file(filepath):
    """Return list of dicts, one per BibTeX entry."""
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    # Strip comments
    content = re.sub(r'%[^\n]*', '', content)
    entries = []
    for m in re.finditer(r'@(\w+)\s*\{([^,]+),(.*?)(?=\n@|\Z)', content, re.DOTALL):
        typ  = m.group(1).lower()
        key  = m.group(2).strip()
        body = m.group(3)
        if typ in ('comment', 'string', 'preamble'):
            continue
        entry = {'type': typ, 'key': key}
        # Parse fields
        for field_m in re.finditer(
            r'\b(\w+)\s*=\s*\{((?:[^{}]|\{[^{}]*\})*)\}', body
        ):
            entry[field_m.group(1).lower()] = field_m.group(2).strip()
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


# ── Field helpers ──────────────────────────────────────────────────────────────

def clean(text):
    """Remove double braces used for BibTeX protection."""
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


# ── LaTeX renderers ────────────────────────────────────────────────────────────

def render_non_atlas_journal(e):
    authors = get(e, 'author')
    title   = get(e, 'title')
    journal = get(e, 'journal')
    volume  = get(e, 'volume')
    number  = get(e, 'number')
    pages   = get(e, 'pages')
    year    = get(e, 'year')
    doi     = get(e, 'doi')
    note    = get(e, 'note')

    vol_str = f"vol.~{volume}" if volume else ''
    num_str = f"No.~{number}" if number else ''
    pag_str = f"pp.~{pages}" if pages else (f"p.~{pages}" if pages else '')
    detail  = ', '.join(x for x in [vol_str, num_str, pag_str, year] if x)

    doi_str = f" \\href{{https://doi.org/{doi}}}{{DOI}}" if doi else ''
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
    year    = get(e, 'year')
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


# ── Section builders ───────────────────────────────────────────────────────────

def build_non_atlas_journals(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = []
    lines.append("\\subsection*{Non-ATLAS Journal Papers}\n")
    lines.append("\\begin{itemize}\n")
    for e in entries:
        lines.append(render_non_atlas_journal(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


def build_atlas_journals(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = []
    lines.append(
        "\\subsection*{Select ATLAS/CERN Collaboration Papers}\n"
        "\\textit{Note: Only a selection is listed. "
        "See Google Scholar and Scopus profiles for the complete list.}\n\n"
    )
    lines.append("\\begin{itemize}\n")
    current_year = None
    for e in entries:
        yr = get(e, 'year')
        if yr != current_year:
            if current_year is not None:
                pass  # could add a visual separator — currently just flows
            current_year = yr
        lines.append(render_atlas_journal(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


def build_conferences(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = []
    lines.append("\\subsection*{Published}\n")
    lines.append("\\begin{itemize}\n")
    for e in entries:
        lines.append(render_conference(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


def build_patents(entries):
    lines = []
    lines.append("\\begin{itemize}\n")
    for e in sorted(entries, key=sort_year, reverse=True):
        lines.append(render_patent(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


def build_bookchapters(entries):
    lines = []
    lines.append("\\begin{itemize}\n")
    for e in sorted(entries, key=sort_year, reverse=True):
        lines.append(render_bookchapter(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


def build_other_scholarly(entries):
    entries = sorted(entries, key=sort_year, reverse=True)
    lines = []
    lines.append("\\begin{itemize}\n")
    for e in entries:
        lines.append(render_other(e))
    lines.append("\\end{itemize}\n")
    return ''.join(lines)


# ── Main ──────────────────────────────────────────────────────────────────────

PLACEHOLDER = "%%AUTO-GENERATED-PUBLICATIONS%%"

def build():
    print("=== CV Builder ===")
    print("Loading .bib files...")
    data = load_all_bibs()

    print("Generating publication sections...")
    pub_block = '\n'.join([
        "% ---- AUTO-GENERATED: do not edit below this line ----",
        "",
        "\\section{Journal Publications}",
        "\\textit{(Accredited Journals. Select {ATLAS}/CERN papers listed below -- "
        "see Google Scholar and Scopus profiles for the full list of 200+ publications.)}",
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

    print(f"Reading template: {MAIN_TEX}")
    with open(MAIN_TEX, encoding="utf-8") as f:
        template = f.read()

    if PLACEHOLDER not in template:
        print(f"ERROR: Placeholder '{PLACEHOLDER}' not found in {MAIN_TEX}")
        sys.exit(1)

    output = template.replace(PLACEHOLDER, pub_block)

    print(f"Writing: {OUT_TEX}")
    with open(OUT_TEX, 'w', encoding="utf-8") as f:
        f.write(output)

    print("Compiling PDF (pass 1)...")
    r = subprocess.run(
        ['pdflatex', '-interaction=nonstopmode', '-output-directory', SCRIPT_DIR, OUT_TEX],
        capture_output=True, text=True, cwd=SCRIPT_DIR
    )
    errors = [l for l in r.stdout.splitlines() if l.startswith('!')]
    if errors:
        print("LaTeX errors:")
        for e in errors:
            print(" ", e)
    else:
        print("Compiling PDF (pass 2 for cross-references)...")
        subprocess.run(
            ['pdflatex', '-interaction=nonstopmode', '-output-directory', SCRIPT_DIR, OUT_TEX],
            capture_output=True, cwd=SCRIPT_DIR
        )
        pdf = OUT_TEX.replace('.tex', '.pdf')
        if os.path.exists(pdf):
            size = os.path.getsize(pdf) // 1024
            print(f"\n✓  Done! PDF: {pdf}  ({size} KB)")
        else:
            print("WARNING: PDF not found after compilation.")


if __name__ == '__main__':
    build()
