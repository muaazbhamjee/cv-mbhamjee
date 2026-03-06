# ============================================================
# Makefile — CV Builder for Prof. Muaaz Bhamjee
# ============================================================
# Usage:
#   make          — build the PDF
#   make clean    — remove LaTeX artefacts
#   make open     — build and open the PDF (macOS/Linux)
#   make watch    — rebuild whenever a source file changes
#                   (requires: brew install fswatch  OR  apt install inotify-tools)
# ============================================================

PYTHON   := python3
PDF      := cv_bhamjee.pdf
SOURCES  := cv_bhamjee_main.tex \
            journals_non_atlas.bib \
            journals_atlas.bib \
            conferences.bib \
            patents.bib \
            bookchapters.bib \
            other_scholarly.bib \
            build.py

.PHONY: all clean open watch

all: $(PDF)

$(PDF): $(SOURCES)
	@echo "→ Building CV..."
	@$(PYTHON) build.py

clean:
	@echo "→ Cleaning build artefacts..."
	@rm -f cv_bhamjee.tex cv_bhamjee.pdf \
	        *.aux *.log *.out *.toc *.fls *.fdb_latexmk \
	        *.synctex.gz *.blg *.bbl
	@echo "   Done."

open: all
	@if command -v open >/dev/null 2>&1; then \
	    open $(PDF); \
	elif command -v xdg-open >/dev/null 2>&1; then \
	    xdg-open $(PDF); \
	else \
	    echo "Cannot detect a PDF viewer — open $(PDF) manually."; \
	fi

# ── Watch mode (rebuilds on any source change) ─────────────
# macOS:  brew install fswatch
# Linux:  sudo apt install inotify-tools
watch:
	@if command -v fswatch >/dev/null 2>&1; then \
	    echo "Watching for changes (fswatch) — Ctrl-C to stop..."; \
	    fswatch -o $(SOURCES) | xargs -n1 -I{} $(MAKE) all; \
	elif command -v inotifywait >/dev/null 2>&1; then \
	    echo "Watching for changes (inotifywait) — Ctrl-C to stop..."; \
	    while inotifywait -e modify $(SOURCES) 2>/dev/null; do $(MAKE) all; done; \
	else \
	    echo "Install fswatch (macOS) or inotify-tools (Linux) to use watch mode."; \
	    exit 1; \
	fi
