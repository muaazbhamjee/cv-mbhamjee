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
#   make publish-site       — build + push PDFs and index.html to muaazbhamjee.github.io
#   make publish-html       — push index.html alone, without rebuilding
#   make watch              — rebuild on any source change
#
# ── One-time submodule setup ─────────────────────────────────
# Run once after cloning, to link the github.io repo:
#
#   make submodule-init
#
# After cloning on a new machine:
#   git clone --recurse-submodules <cv-repo-url>
#   or: make submodule-init   (if already cloned)
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

# ── github.io submodule ──────────────────────────────────────
SITE_URL    := https://github.com/muaazbhamjee/muaazbhamjee.github.io.git
SITE_BRANCH := main

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
        publish publish-site publish-html submodule-init watch

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

# ── Site submodule guard ─────────────────────────────────────
# Pushing needs site/ cloned *and* on a branch: git submodule
# update leaves a detached HEAD, which commits fine but cannot
# be pushed. make submodule-init fixes both cases.
define check_site
	@if [ ! -e "site/.git" ]; then \
	    echo "ERROR: site/ submodule not initialised."; \
	    echo "       Run: make submodule-init"; \
	    exit 1; \
	fi
	@if [ -z "$$(cd site && git branch --show-current)" ]; then \
	    echo "ERROR: site/ is on a detached HEAD — nothing to push to."; \
	    echo "       Run: make submodule-init"; \
	    exit 1; \
	fi
endef

# ── Publish-site: push PDFs + index.html to muaazbhamjee.github.io
# The build mirrors index.html into site/, so this publishes the
# homepage and the PDFs together — publish-html is for pushing
# index.html on its own, without rebuilding the documents.
# Requires the site/ submodule to be initialised (see setup above).
# Usage:  make publish-site
#         make publish-site msg="Update CV and statement $(TODAY)"
publish-site: all
	$(check_site)
	@echo "→ Pushing PDFs and index.html to muaazbhamjee.github.io..."
	@cd site && \
	    git add *.pdf index.html && \
	    git diff --cached --quiet && echo "   Nothing to publish." || \
	    ( git commit -m "$(if $(msg),$(msg),Update PDFs $(TODAY))" && \
	      git push && \
	      echo "   ✓  Live at https://muaazbhamjee.github.io" )
	@git add site
	@git diff --cached --quiet || \
	    git commit -m "Update site submodule ref $(TODAY)"
	@git push


# ── Publish-html: push index.html to muaazbhamjee.github.io ──
# Copies index.html into site/, commits, and pushes.
# Usage:  make publish-html
#         make publish-html msg="Update homepage"
publish-html:
	$(check_site)
	@echo "→ Publishing index.html to muaazbhamjee.github.io..."
	@cp index.html site/index.html
	@cd site && \
	    git add index.html && \
	    git diff --cached --quiet && echo "   No changes to index.html." || \
	    ( git commit -m "$(if $(msg),$(msg),Update homepage $(TODAY))" && \
	      git push && \
	      echo "   ✓  Live at https://muaazbhamjee.github.io" )
	@git add site
	@git diff --cached --quiet || \
	    git commit -m "Update site submodule ref $(TODAY)"
	@git push

# ── Submodule init helper ────────────────────────────────────
# Handles every state site/ can be in:
#   cloned already      — left alone
#   in .gitmodules but  — cloned; stray build-copied PDFs are
#   not cloned            cleared first, since git refuses to
#                         clone into a non-empty directory
#   not registered      — added
# Then puts it on $(SITE_BRANCH), so publish-* can push.
submodule-init:
	@if [ -e "site/.git" ]; then \
	    echo "   site/ already initialised."; \
	elif git config --file .gitmodules --get submodule.site.url >/dev/null 2>&1; then \
	    echo "→ site/ registered but not cloned — initialising..."; \
	    rm -f site/*.pdf; \
	    rmdir site 2>/dev/null || true; \
	    if [ -e "site" ]; then \
	        echo "ERROR: site/ exists and is not empty — move it aside and retry."; \
	        exit 1; \
	    fi; \
	    git submodule update --init site; \
	else \
	    echo "→ Adding site/ submodule..."; \
	    git submodule add $(SITE_URL) site; \
	fi
	@cd site && \
	    if [ -z "$$(git branch --show-current)" ]; then \
	        echo "→ site/ on detached HEAD — checking out $(SITE_BRANCH)..."; \
	        git checkout $(SITE_BRANCH); \
	    fi
	@echo "   ✓  site/ ready on branch $$(cd site && git branch --show-current)"

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
