DIR=pdflatex
DOC=main
BIB=mybib.bib biblio.bib

FIGS=./Figs

all: $(DIR) $(DOC).tex $(BIB)
	pdflatex -output-directory $(DIR) $(DOC)
	bibtex $(DIR)/$(DOC).aux
	pdflatex -output-directory $(DIR) $(DOC)
	pdflatex -output-directory $(DIR) $(DOC)
	cp $(DIR)/$(DOC).pdf .

#	twopi -Tps $(FIGS)/architecture_sensors.dot > $(FIGS)/architecture_sensors.ps
#	ps2epsi $(FIGS)/architecture_sensors.ps $(FIGS)/architecture_sensors.epsi
#	epstopdf $(FIGS)/architecture_sensors.epsi

$(DIR):
	mkdir -p $(DIR)

.PHONY: clean
clean:
	rm -rf $(DIR)
