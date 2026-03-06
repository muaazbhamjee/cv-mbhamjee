# ============================================================
# Makefile — Academic Documents, Prof. Muaaz Bhamjee
# ============================================================
# Usage:
#   make                    — build all documents
#   make cv                 — build CV only
#   make statement          — build NITheCS statement only
#   make clean              — remove LaTeX artefacts (PDFs preserved)
#   make clean-all          — remove artefacts AND all generated PDFs
#   make open               — build all and open both PDFs
#   make open-cv            — build and open CV only
#   make open-stmt          — build and open NITheCS statement only
#   make publish            — push docs/ to cv-bhamjee repo
#   make publish-site       — build + push PDFs to muaazbhamjee.github.io
#   make watch              — rebuild on any source change
#
# ── One-time submodule setup ─────────────────────────────────
# Run once after cloning, to link the github.io repo:
#
#   git submodule add https://github.com/muaazbhamjee/muaazbhamjee.github.io.git site
#   git submodule update --init
#
# After cloning on a new machine:
#   git clone --recurse-submodules <cv-repo-url>
#   or: git submodule update --init   (if already cloned)
#
# ── pdflatex override ────────────────────────────────────────
# build.py auto-detects Windows TeX Live / MiKTeX via WSL.
# Override if needed:
#   make PDFLATEX=/mnt/c/texlive/2024/bin/windows/pdflatex.exe
#
# Or set permanently in ~/.bashrc:
#   export PDFLATEX=/mnt/c/texlive/2024/bin/windows/pdflatex.exe
# ============================================================

PYTHON := python3
TODAY  := $(shell date +'%Y-%m-%d')

ifdef PDFLATEX
  BUILD := PDFLATEX=$(PDFLATEX) $(PYTHON) build.py
else
  BUILD := $(PYTHON) build.py
endif

# ── Sources ──────────────────────────────────────────────────
CV_SOURCES := cv_bhamjee_main.tex \
              journals_non_atlas.bib \
              journals_atlas.bib \
              conferences.bib \
              patents.bib \
              bookchapters.bib \
              other_scholarly.bib

STMT_SOURCES := nithecs_statement.tex

ALL_SOURCES  := $(CV_SOURCES) $(STMT_SOURCES)

.PHONY: all cv statement clean clean-all open open-cv open-stmt \
        publish publish-site submodule-init watch

# ── Default: build everything ────────────────────────────────
all: $(ALL_SOURCES)
	@$(BUILD)

# ── Individual documents ─────────────────────────────────────
cv: $(CV_SOURCES)
	@$(BUILD) cv

statement: $(STMT_SOURCES)
	@$(BUILD) statement

# ── Clean: artefacts only — PDFs preserved ───────────────────
clean:
	@echo "→ Removing LaTeX artefacts (PDFs preserved)..."
	@rm -f cv_bhamjee.tex \
	        *.aux *.log *.out *.toc *.fls *.fdb_latexmk \
	        *.synctex.gz *.blg *.bbl
	@echo "   Done."

# ── Clean-all: artefacts + all generated PDFs ────────────────
clean-all: clean
	@echo "→ Removing generated PDFs..."
	@rm -f docs/*.pdf
	@echo "   Done. Rebuild with: make"

# ── Open helpers ─────────────────────────────────────────────
define open_pdf
	@if command -v open >/dev/null 2>&1; then \
	    open $(1); \
	elif command -v xdg-open >/dev/null 2>&1; then \
	    xdg-open $(1); \
	elif command -v wslview >/dev/null 2>&1; then \
	    wslview $(1); \
	elif command -v explorer.exe >/dev/null 2>&1; then \
	    explorer.exe $(shell wslpath -w $(1) 2>/dev/null || echo $(1)); \
	else \
	    echo "Cannot detect a PDF viewer — open $(1) manually."; \
	fi
endef

open: all
	$(call open_pdf,docs/cv_bhamjee.pdf)
	$(call open_pdf,docs/nithecs_statement.pdf)

open-cv: cv
	$(call open_pdf,docs/cv_bhamjee.pdf)

open-stmt: statement
	$(call open_pdf,docs/nithecs_statement.pdf)

# ── Publish: push docs/ in the CV repo ───────────────────────
# Usage:  make publish msg="Add JHEP paper March 2026"
publish: all
	@echo "→ Staging docs/ in cv-bhamjee repo..."
	@git add docs/
	@git diff --cached --name-only | grep 'docs/' || echo "   No changes in docs/."
	@if [ -n "$(msg)" ]; then \
	    git commit -m "$(msg)" && git push && echo "   ✓  cv-bhamjee repo updated."; \
	else \
	    echo "   Staged. Run:  git commit -m 'your message' && git push"; \
	fi

# ── Publish-site: push PDFs to muaazbhamjee.github.io ────────
# Requires the site/ submodule to be initialised (see setup above).
# Usage:  make publish-site
#         make publish-site msg="Update CV and statement $(TODAY)"
publish-site: all
	@if [ ! -d "site/.git" ]; then \
	    echo "ERROR: site/ submodule not initialised."; \
	    echo "       Run: git submodule add https://github.com/muaazbhamjee/muaazbhamjee.github.io.git site"; \
	    exit 1; \
	fi
	@echo "→ Pushing PDFs to muaazbhamjee.github.io..."
	@cd site && \
	    git add *.pdf && \
	    git diff --cached --quiet && echo "   No PDF changes to publish." || \
	    ( git commit -m "$(if $(msg),$(msg),Update PDFs $(TODAY))" && \
	      git push && \
	      echo "   ✓  Live at https://muaazbhamjee.github.io" )
	@git add site
	@git diff --cached --quiet || \
	    git commit -m "Update site submodule ref $(TODAY)"
	@git push

# ── Submodule init helper ────────────────────────────────────
submodule-init:
	@if [ -d "site" ]; then \
	    echo "site/ already exists — skipping."; \
	else \
	    git submodule add https://github.com/muaazbhamjee/muaazbhamjee.github.io.git site && \
	    echo "   ✓  site/ submodule added."; \
	fi

# ── Watch mode ───────────────────────────────────────────────
# macOS:  brew install fswatch
# Linux:  sudo apt install inotify-tools
watch:
	@if command -v fswatch >/dev/null 2>&1; then \
	    echo "Watching for changes (fswatch) — Ctrl-C to stop..."; \
	    fswatch -o $(ALL_SOURCES) | xargs -n1 -I{} $(MAKE) all; \
	elif command -v inotifywait >/dev/null 2>&1; then \
	    echo "Watching for changes (inotifywait) — Ctrl-C to stop..."; \
	    while inotifywait -e modify $(ALL_SOURCES) 2>/dev/null; do $(MAKE) all; done; \
	else \
	    echo "Install fswatch (macOS) or inotify-tools (Linux) to use watch mode."; \
	    exit 1; \
	fi
