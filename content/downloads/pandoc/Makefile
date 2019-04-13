rhhi_ra_md := ibb\ rhhi\ ra.md
rhhi_ra_pdf := ibb\ rhhi\ ra.pdf
rhhi_ra_docx := ibb\ rhhi\ ra.docx
loc_ra_md := loc\ ra.md
loc_ra_pdf := loc\ ra.pdf
loc_ra_docx := loc\ ra.docx

all: rhhi_ra_pdf rhhi_ra_docx loc_ra_pdf loc_ra_docx

rhhi_ra_pdf: $(rhhi_ra_md) latex.yaml
	pandoc latex.yaml $(rhhi_ra_md) \
	--number-sections \
	--from markdown \
	-o $(rhhi_ra_pdf) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--pdf-engine xelatex \
	--template eisvogel.tex \
	-M date="`date "+%B %e, %Y"`" \
	-V links-as-notes=true

rhhi_ra_docx: $(rhhi_ra_md) latex.yaml
	pandoc $(rhhi_ra_md) \
	--from markdown \
	-o $(rhhi_ra_docx) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--columns 10

loc_ra_pdf: $(loc_ra_md) latex.yaml
	pandoc latex.yaml $(loc_ra_md) \
	--number-sections \
	--from markdown \
	-o $(loc_ra_pdf) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--pdf-engine xelatex \
	--template eisvogel.tex \
	-M date="`date "+%B %e, %Y"`" \
	-V links-as-notes=true

loc_ra_docx: $(loc_ra_md) latex.yaml
	pandoc $(loc_ra_md) \
	--from markdown \
	-o $(loc_ra_docx) \
	--highlight-style pygments \
	--filter pandoc-fignos \
	--listings \
	--columns 10
