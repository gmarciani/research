requirements:
	brew install --cask basictex
	sudo tlmgr update --self
	sudo tlmgr update --all
	sudo tlmgr install latexmk tagpdf mitthesis titlesec doi mhchem lipsum biblatex biblatex-ieee biber
build:
	latexmk -pdf main.tex
clean:
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