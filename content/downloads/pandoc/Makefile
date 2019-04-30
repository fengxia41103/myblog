latex_template := feng.tex
rhhi_ra_md := ibb\ rhhi\ ra.md
rhhi_ra_pdf := ibb\ rhhi\ ra.pdf
rhhi_ra_docx := ibb\ rhhi\ ra.docx
rhhi_ra_tex := ibb\ rhhi\ ra.tex
loc_ra_md := loc\ ra.md
loc_ra_pdf := loc\ ra.pdf
loc_ra_docx := loc\ ra.docx

# Citation style language
# A full list:
# - https://github.com/citation-style-language/styles
csl := ieee-with-url.csl

all: rhhi_ra_pdf rhhi_ra_docx loc_ra_pdf loc_ra_docx

rhhi_ra: rhhi_ra_pdf rhhi_ra_docx rhhi_ra_tex
loc_ra: loc_ra_pdf loc_ra_docx

rhhi_ra_tex: $(rhhi_ra_md) latex.yaml
	pandoc latex.yaml $(rhhi_ra_md) \
	--number-sections \
	--from markdown \
	-o $(rhhi_ra_tex) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--template $(latex_template) \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(csl)

rhhi_ra_pdf: $(rhhi_ra_md) latex.yaml
	pandoc latex.yaml $(rhhi_ra_md) \
	--number-sections \
	--from markdown \
	-o $(rhhi_ra_pdf) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--pdf-engine xelatex \
	--template $(latex_template) \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(csl)

rhhi_ra_docx: $(rhhi_ra_md) latex.yaml
	pandoc $(rhhi_ra_md) \
	--from markdown \
	-o $(rhhi_ra_docx) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--columns 10 \
	--filter pandoc-citeproc \
	--csl $(csl)


loc_ra_pdf: $(loc_ra_md) latex.yaml
	pandoc latex.yaml $(loc_ra_md) \
	--number-sections \
	--from markdown \
	-o $(loc_ra_pdf) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--pdf-engine xelatex \
	--template $(latex_template) \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(csl)

loc_ra_docx: $(loc_ra_md) latex.yaml
	pandoc $(loc_ra_md) \
	--from markdown \
	-o $(loc_ra_docx) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--columns 10 \
	--filter pandoc-citeproc \
	--csl $(csl)
