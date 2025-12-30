# Makefile — build main.pdf from the LaTeX sources

.PHONY: help setup build view watch clean

help: ## show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-10s %s\n", $$1, $$2}'

setup: ## install LaTeX dependencies (once)
	brew install --cask basictex
	brew install fswatch
	sudo tlmgr update --self
	sudo tlmgr update --all
	sudo tlmgr install latexmk tagpdf mitthesis titlesec doi mhchem lipsum biblatex biblatex-ieee biber

build: ## build main.pdf (default)
	latexmk -pdf main.tex

view: ## open the built PDF (does not build; errors if missing)
	open main.pdf

watch: build ## open the PDF and rebuild it whenever a source file changes
	@open main.pdf
	@echo "Watching for changes (Ctrl-C to stop)..."
	@fswatch -o --latency 1 . | while read -r _; do $(MAKE) build && open -g main.pdf; done

clean: ## remove build artifacts
	rm -rf sec/*.aux
	rm -rf *.aux
	rm -rf *.bbl
	rm -rf *.bcf
	rm -rf *.fdb_latexmk
	rm -rf *.fls
	rm -rf *.log
	rm -rf *.pdf
	rm -rf *.pyg
	rm -rf *.run.xml
	rm -rf *.synctex.gz
	rm -rf *.toc