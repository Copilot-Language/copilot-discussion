.PHONY: clean veryclean

WORK_DIR=pdflatex
TGT=copilot_tutorial
latex=pdflatex -output-directory $(WORK_DIR)
bibtex=bibtex 

all: $(TGT).pdf

$(TGT).pdf: $(WORK_DIR) $(TGT).tex
	$(latex) $(TGT)
	$(bibtex) $(WORK_DIR)/$(TGT)
	$(latex) $(TGT)
	$(latex) $(TGT)
	cp $(WORK_DIR)/$(TGT).pdf .

$(WORK_DIR):
	mkdir -p $(WORK_DIR)

clean:
	-rm -rf $(WORK_DIR)

veryclean: clean
	-rm $(TGT).pdf
