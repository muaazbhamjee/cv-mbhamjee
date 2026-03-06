# ============================================================
# Makefile — Academic Documents, Prof. Muaaz Bhamjee
# ============================================================
# Usage:
#   make              — build all documents
#   make cv           — build CV only
#   make statement    — build NITheCS statement only
#   make clean        — remove LaTeX artefacts (PDFs preserved)
#   make clean-all    — remove artefacts AND all generated PDFs
#   make open         — build all and open both PDFs
#   make open-cv      — build and open CV only
#   make open-stmt    — build and open NITheCS statement only
#   make publish      — stage docs/, commit, and push
#   make watch        — rebuild on any source change
#                       (requires: brew install fswatch  OR
#                                  apt install inotify-tools)
#
# ── pdflatex override ────────────────────────────────────────
# build.py auto-detects Windows TeX Live / MiKTeX via WSL.
# Override here if auto-detection picks the wrong binary:
#
#   TeX Live (WSL):
#     make PDFLATEX=/mnt/c/texlive/2024/bin/windows/pdflatex.exe
#
#   MiKTeX (WSL):
#     make PDFLATEX="/mnt/c/Users/<user>/AppData/Local/Programs/MiKTeX/miktex/bin/x64/pdflatex.exe"
#
#   Or export it in your shell's .bashrc / .zshrc:
#     export PDFLATEX=/mnt/c/texlive/2024/bin/windows/pdflatex.exe
# ============================================================

PYTHON   := python3

# Pass PDFLATEX through to build.py (empty = let build.py auto-detect)
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
              other_scholarly.bib \
              build.py

STMT_SOURCES := nithecs_statement.tex build.py

ALL_SOURCES  := $(CV_SOURCES) $(STMT_SOURCES)

.PHONY: all cv statement clean clean-all open open-cv open-stmt publish watch

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
	@rm -f cv_bhamjee.pdf nithecs_statement.pdf
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
	    explorer.exe $(shell wslpath -w $(1)); \
	else \
	    echo "Cannot detect a PDF viewer — open $(1) manually."; \
	fi
endef

open: all
	$(call open_pdf,cv_bhamjee.pdf)
	$(call open_pdf,nithecs_statement.pdf)

open-cv: cv
	$(call open_pdf,cv_bhamjee.pdf)

open-stmt: statement
	$(call open_pdf,nithecs_statement.pdf)

# ── Publish docs/ to GitHub Pages ────────────────────────────
# Usage:  make publish msg="Update CV March 2026"
publish: all
	@echo "→ Staging docs/ for GitHub Pages..."
	@git add docs/
	@git diff --cached --name-only | grep 'docs/' || echo "   No changes in docs/ to stage."
	@if [ -n "$(msg)" ]; then \
	    git commit -m "$(msg)"; \
	    git push; \
	    echo "   ✓  Published."; \
	else \
	    echo "   Staged. Run:  git commit -m 'your message' && git push"; \
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
