# Latex template
LATEX_TEMPLATE := lenovo.tex
LATEX_CONFIG := latex.yaml

# Links to images, and bibtex reference section header
REFERENCES := references.md

# CSS
MY_CSS := pandoc.css

# Citation style language
# A full list:
# - https://github.com/citation-style-language/styles
CSL := ieee-with-url.csl

# Pandoc flags
COMMON_FLAGS = 	--number-sections \
	--from markdown \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--filter mermaid-filter \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(CSL) \
	--toc \

HTML_FLAGS = $(COMMON_FLAGS) \
	--standalone \
	-f markdown+smart \
	--to=html5 \
	--css $(MY_CSS)

PDF_FLAGS = $(COMMON_FLAGS) \
	--listings \
	--template $(LATEX_TEMPLATE) \

DOCX_FLAGS = $(COMMON_FLAGS) \
	--columns 10



# RHHI source and target
rhhi_ra_md := ibb\ rhhi\ ra.md
RHHI_RA_INPUTS = $(rhhi_ra_md) $(REFERENCES)

rhhi_ra_pdf := ibb\ rhhi\ ra.pdf
rhhi_ra_docx := ibb\ rhhi\ ra.docx
rhhi_ra_html := ibb\ rhhi\ ra.html

# LOC source and target
loc_ra_md := loc\ ra.md
LOC_RA_INPUTS = $(loc_ra_md) $(REFERENCES)

loc_ra_pdf := loc\ ra.pdf
loc_ra_docx := loc\ ra.docx
loc_ra_html := loc\ ra.html

rhhi_ra: rhhi_ra_pdf rhhi_ra_docx  rhhi_ra_html
loc_ra: loc_ra_pdf loc_ra_docx loc_ra_html
all: rhhi_ra loc_ra


rhhi_ra_html: $(RHHI_RA_INPUTS)
	pandoc $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_html) \
	$(HTML_FLAGS)

rhhi_ra_pdf: $(RHHI_RA_INPUTS) $(LATEX_CONFIG)
	pandoc $(LATEX_CONFIG) $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_pdf) \
	$(PDF_FLAGS)

rhhi_ra_docx: $(RHHI_RA_INPUTS) $(LATEX_CONFIG)
	pandoc $(LATEX_CONFIG) $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_docx) \
	$(DOCX_FLAGS)

loc_ra_html: $(LOC_RA_INPUTS)
	pandoc $(LOC_RA_INPUTS) \
	-o $(loc_ra_html) \
	$(HTML_FLAGS)

loc_ra_pdf: $(LOC_RA_INPUTS) $(LATEX_CONFIG)
	pandoc $(LATEX_CONFIG) $(LOC_RA_INPUTS) \
	-o $(loc_ra_pdf) \
	$(PDF_FLAGS)

loc_ra_docx: $(LOC_RA_INPUTS) $(LATEX_CONFIG)
	pandoc $(LATEX_CONFIG) $(LOC_RA_INPUTS) \
	-o $(loc_ra_docx) \
	$(DOCX_FLAGS)

clean:
	rm -f *.pdf *.docx *.html
