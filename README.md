# CV — Prof. Muaaz Bhamjee

LaTeX CV with a Python-driven publication system. Research outputs are stored in
BibTeX files and automatically injected into the CV at build time.  
You never edit the publication lists in LaTeX directly.

---

## Quick start

```bash
# 1. Clone
git clone https://github.com/<your-username>/cv-bhamjee.git
cd cv-bhamjee

# 2. Install dependencies (once)
#    macOS:   brew install --cask mactex   (or BasicTeX)
#    Ubuntu:  sudo apt install texlive-latex-recommended texlive-fonts-recommended

# 3. Build
make

# 4. Open the PDF
make open
```

---

## Repository structure

```
cv-bhamjee/
├── build.py                  # reads .bib files → generates cv_bhamjee.tex → compiles PDF
├── Makefile                  # convenience wrapper around build.py
├── cv_bhamjee_main.tex       # CV template (everything except publications)
│
├── journals_non_atlas.bib    # Your own journal papers
├── journals_atlas.bib        # ATLAS / CERN collaboration journal papers
├── conferences.bib           # Conference papers
├── patents.bib               # Patents
├── bookchapters.bib          # Book chapters
├── other_scholarly.bib       # Talks, posters, open-source models, etc.
│
├── .gitignore                # excludes build artefacts and generated files
├── Makefile
└── README.md
```

> **`cv_bhamjee.tex` and `cv_bhamjee.pdf` are not tracked by Git.**  
> They are build outputs — regenerate them with `make`.

---

## How to add a new publication

### 1. Find the right `.bib` file

| Type | File |
|---|---|
| Your own journal paper | `journals_non_atlas.bib` |
| ATLAS / CERN paper | `journals_atlas.bib` |
| Conference paper | `conferences.bib` |
| Patent | `patents.bib` |
| Book chapter | `bookchapters.bib` |
| Talk, poster, software, dataset | `other_scholarly.bib` |

### 2. Paste in the BibTeX entry

Most journals and Google Scholar provide a "Cite → BibTeX" export button.
Paste the entry at the **top** of the relevant `.bib` file (newest first is convention,
but `build.py` sorts by year automatically so order doesn't matter).

**Minimal example — journal paper:**
```bibtex
@article{bhamjee2026newpaper,
  author  = {Bhamjee, Muaaz and Connell, Simon H.},
  title   = {A New Result on Multiphase Flow},
  journal = {Journal of Fluid Mechanics},
  volume  = {999},
  pages   = {1--20},
  year    = {2026},
  doi     = {10.xxxx/xxxxxx},
}
```

**Minimal example — conference paper:**
```bibtex
@inproceedings{bhamjee2026conf,
  author    = {Bhamjee, Muaaz and Smith, Jane},
  title     = {Deep Learning for CFD Surrogate Models},
  booktitle = {SACAM 2026},
  address   = {Cape Town},
  pages     = {1--8},
  year      = {2026},
}
```

### 3. Rebuild

```bash
make
```

### 4. Commit

```bash
git add journals_non_atlas.bib        # or whichever file you edited
git commit -m "Add JFM paper 2026"
git push
```

---

## How to update ATLAS papers

ATLAS output is prolific. The recommended cadence is **once or twice a year**:

1. Go to your [Google Scholar profile](https://scholar.google.co.za/citations?user=jlO-JkoAAAAJ)
2. Select all → Export → **BibTeX**
3. Open the downloaded file and copy any new ATLAS entries into `journals_atlas.bib`
4. Run `make` — duplicates won't appear because each entry has a unique key

---

## How to update non-publication content

Edit `cv_bhamjee_main.tex` directly for:

- Personal details / contact information
- Employment history
- Education
- Research profile metrics (h-index etc.)
- Grants
- Supervision
- Reviewing / committee memberships
- References

Then run `make`.

---

## Editing on a server / without a local LaTeX install

If you have a remote Linux server with `pdflatex`:

```bash
ssh yourserver
git clone https://github.com/<your-username>/cv-bhamjee.git
cd cv-bhamjee
sudo apt install texlive-latex-recommended texlive-fonts-recommended python3
make
scp cv_bhamjee.pdf local:~/Desktop/
```

Or use [Overleaf](https://overleaf.com) for the template editing — but note that
**`build.py` cannot run on Overleaf**. If you move to Overleaf you would need to
manually paste the generated `cv_bhamjee.tex` there.

---

## Dependencies

| Tool | Purpose | Install |
|---|---|---|
| Python 3.6+ | Runs `build.py` | Usually pre-installed |
| `pdflatex` | Compiles LaTeX → PDF | See below |
| `fswatch` *(optional)* | `make watch` on macOS | `brew install fswatch` |
| `inotify-tools` *(optional)* | `make watch` on Linux | `apt install inotify-tools` |

**LaTeX installation:**

```bash
# macOS
brew install --cask mactex-no-gui   # ~4 GB, full install
# or
brew install --cask basictex        # ~100 MB minimal

# Ubuntu / Debian
sudo apt install texlive-latex-recommended texlive-fonts-recommended \
                 texlive-latex-extra

# Arch
sudo pacman -S texlive-most
```

---

## Make targets

| Command | Action |
|---|---|
| `make` | Build the PDF |
| `make clean` | Remove all generated files and LaTeX artefacts |
| `make open` | Build and open the PDF in your default viewer |
| `make watch` | Rebuild automatically whenever a source file changes |
