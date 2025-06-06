# Latex template
LATEX_TEMPLATE := feng.tex
LATEX_REPORT_CONFIG := latex.yaml
LATEX_ARTICLE_CONFIG := article-latex.yaml

# DHHS
LATEX_DHHS_TEMPLATE := dhhs-template.tex
LATEX_DHHS_CONFIG := dhhs-latex.yaml

# if writing letter
LATEX_LETTER_TEMPLATE := template-letter.tex
LATEX_LETTER_CONFIG := letter-latex.yaml

# Links to images, and bibtex reference section header
REFERENCES := references.md

# CSS
MY_CSS := pandoc.css

# Citation style language
# A full list:
# - https://github.com/citation-style-language/styles
CSL := ieee-with-url.csl

# Pandoc flags
COMMON_FLAGS = 	+RTS -M3000m -RTS\
	--number-sections \
	--from markdown \
	--highlight-style pygments \
	--filter pandoc-fignos \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(CSL) \
	--toc

HTML_FLAGS = $(COMMON_FLAGS) \
	--standalone \
	-f markdown+smart \
	--to=html5 \
	--css $(MY_CSS)

PDF_FLAGS = $(COMMON_FLAGS) \
	--listings \
	--template $(LATEX_TEMPLATE) \
	--pdf-engine=xelatex

DHHS_PDF_FLAGS = +RTS -M3000m -RTS\
	--number-sections \
	--from markdown \
	--highlight-style pygments \
	--filter pandoc-fignos \
	-M date="`date "+%B %e, %Y"`" \
	--filter pandoc-citeproc \
	--csl $(CSL) \
	--toc \
	--template $(LATEX_DHHS_TEMPLATE) \
	--pdf-engine=xelatex

DOCX_FLAGS = $(COMMON_FLAGS) \
	--columns 10

LETTER_FLAGS = +RTS -M3000m -RTS\
	--from markdown \
	--highlight-style pygments \
	-M date="`date "+%B %e, %Y"`" \
	--template $(LATEX_LETTER_TEMPLATE) \
	--pdf-engine=xelatex

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
loc_ra_tex := loc\ ra.tex
loc_ra_docx := loc\ ra.docx
loc_ra_html := loc\ ra.html

# Webapp source and target
webapp_md := webapp.md
WEBAPP_INPUTS = $(webapp_md) $(REFERENCES)

webapp_pdf := webapp.pdf
webapp_docx := webapp.docx
webapp_html := webapp.html
webapp_tex := webapp.tex

# resume source and target
resume_md := resume.md
RESUME_INPUTS = $(resume_md)
resume_pdf := ../feng\ xia\ resume.pdf
resume_docx := ../feng\ xia\ resume.docx

resume_devops_md := resume-devops.md
RESUME_DEVOPS_INPUTS = $(resume_devops_md)
resume_devops_pdf := ../feng\ xia\ resume\ devops.pdf

# cover letter
cover_letter_md := cover\ letter.md
COVER_LETTER_INPUTS = $(cover_letter_md)
cover_letter_tex := cover_letter.tex
cover_letter_pdf := cover_letter.pdf

# personal referral
personal_referral_md := personal\ referral.md
PERSONAL_REFERRAL_INPUTS = $(personal_referral_md)
personal_referral_pdf := personal_referral.pdf

# git startegy article
git_md := git\ strategy.md
GIT_INPUTS = $(git_md) $(REFERENCES)
git_pdf := git.pdf

# netbox proposal
netbox_md := netbox.md
NETBOX_INPUTS = $(netbox_md) $(REFERENCES)
netbox_pdf := netbox.pdf
netbox_docx := netbox.docx

# UNC article
unc_md := unc.md
UNC_INPUTS = $(unc_md) $(REFERENCES)
unc_pdf := unc.pdf
unc_docx := unc.docx

# lucidum
lucidum_md := lucidum.md
LUCIDUM_INPUTS = $(lucidum_md) $(REFERENCES)
lucidum_pdf := lucidum.pdf
lucidum_docx := lucidum.docx
lucidum_html := lucidum.html

# cwis
cwis_md := cwis.md
CWIS_INPUTS = $(cwis_md) $(REFERENCES)
cwis_pdf := cwis.pdf
cwis_docx := cwis.docx
cwis_html := cwis.html
cwis_tex := cwis.tex

rhhi_ra: rhhi_ra_pdf rhhi_ra_docx  rhhi_ra_html
loc_ra: loc_ra_pdf loc_ra_docx loc_ra_html
webapp: webapp_pdf webapp_docx webapp_html
resume: resume_pdf resume_docx resume_devops_pdf
cover_letter: cover_letter_pdf
git: git_pdf
netbox: netbox_pdf netbox_docx
unc: unc_pdf unc_docx
lucidum: lucidum_pdf lucidum_docx lucidum_html
personal_referral: personal_referral_pdf
cwis: cwis_html cwis_tex cwis_pdf

all: rhhi_ra loc_ra webapp resume git netbox unc cover_letter personal_referral cwis


rhhi_ra_html: $(RHHI_RA_INPUTS)
	pandoc $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_html) \
	$(HTML_FLAGS)

rhhi_ra_pdf: $(RHHI_RA_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_pdf) \
	$(PDF_FLAGS)

rhhi_ra_docx: $(RHHI_RA_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(RHHI_RA_INPUTS) \
	-o $(rhhi_ra_docx) \
	$(DOCX_FLAGS)

loc_ra_html: $(LOC_RA_INPUTS)
	pandoc $(LOC_RA_INPUTS) \
	-o $(loc_ra_html) \
	$(HTML_FLAGS)

loc_ra_pdf: $(LOC_RA_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(LOC_RA_INPUTS) \
	-o $(loc_ra_pdf) \
	$(PDF_FLAGS)

loc_ra_docx: $(LOC_RA_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(LOC_RA_INPUTS) \
	-o $(loc_ra_docx) \
	$(DOCX_FLAGS)

loc_ra_tex: $(LOC_RA_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(LOC_RA_INPUTS) \
	-o $(loc_ra_tex) \
	$(PDF_FLAGS)

webapp_html: $(WEBAPP_INPUTS)
	pandoc $(WEBAPP_INPUTS) \
	-o $(webapp_html) \
	$(HTML_FLAGS)

webapp_pdf: $(WEBAPP_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(WEBAPP_INPUTS) \
	-o $(webapp_pdf) \
	$(PDF_FLAGS)

webapp_docx: $(WEBAPP_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(WEBAPP_INPUTS) \
	-o $(webapp_docx) \
	$(DOCX_FLAGS)

webapp_tex: $(WEBAPP_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(WEBAPP_INPUTS) \
	-o $(webapp_tex) \
	$(PDF_FLAGS)

resume_pdf: $(RESUME_INPUTS)
	pandoc \
	-s \
	-t latex \
	-o $(resume_pdf) \
	--pdf-engine=xelatex \
	$(RESUME_INPUTS)

resume_docx: $(RESUME_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(RESUME_INPUTS) \
	-o $(resume_docx) \
	$(DOCX_FLAGS)

personal_referral_pdf: $(PERSONAL_REFERRAL_INPUTS)
	pandoc \
	-s \
	-t latex \
	-o $(personal_referral_pdf) \
	--pdf-engine=xelatex \
	$(PERSONAL_REFERRAL_INPUTS)

resume_devops_pdf: $(RESUME_DEVOPS_INPUTS)
	pandoc \
	-s \
	-t latex \
	-o $(resume_devops_pdf) \
	--pdf-engine=xelatex \
	$(RESUME_DEVOPS_INPUTS)

cover_letter_pdf: $(COVER_LETTER_INPUTS) $(LATEX_LETTER_CONFIG)
	pandoc $(LATEX_LETTER_CONFIG) $(COVER_LETTER_INPUTS) \
	-o $(cover_letter_pdf) \
	$(LETTER_FLAGS)


git_pdf: $(GIT_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_ARTICLE_CONFIG) $(GIT_INPUTS) \
	-o $(git_pdf) \
	$(PDF_FLAGS)

netbox_pdf: $(NETBOX_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_ARTICLE_CONFIG) $(NETBOX_INPUTS) \
	-o $(netbox_pdf) \
	$(PDF_FLAGS)

netbox_docx: $(NETBOX_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(NETBOX_INPUTS) \
	-o $(netbox_docx) \
	$(DOCX_FLAGS)

unc_pdf: $(UNC_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_ARTICLE_CONFIG) $(UNC_INPUTS) \
	-o $(unc_pdf) \
	$(PDF_FLAGS)

unc_docx: $(UNC_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(UNC_INPUTS) \
	-o $(unc_docx) \
	$(DOCX_FLAGS)

lucidum_pdf: $(LUCIDUM_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_ARTICLE_CONFIG) $(LUCIDUM_INPUTS) \
	-o $(lucidum_pdf) \
	$(PDF_FLAGS)

lucidum_docx: $(LUCIDUM_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(LUCIDUM_INPUTS) \
	-o $(lucidum_docx) \
	$(DOCX_FLAGS)

lucidum_html: $(LUCIDUM_INPUTS)
	pandoc $(LUCIDUM_INPUTS) \
	-o $(lucidum_html) \
	$(HTML_FLAGS)

cwis_docx: $(CWIS_INPUTS) $(LATEX_REPORT_CONFIG)
	pandoc $(LATEX_REPORT_CONFIG) $(CWIS_INPUTS) \
	-o $(cwis_docx) \
	$(DOCX_FLAGS)

cwis_html: $(CWIS_INPUTS)
	pandoc $(CWIS_INPUTS) \
	-o $(cwis_html) \
	$(HTML_FLAGS)

cwis_pdf: $(CWIS_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_DHHS_CONFIG) $(CWIS_INPUTS) \
	-o $(cwis_pdf) \
	$(DHHS_PDF_FLAGS)

cwis_tex: $(CWIS_INPUTS) $(LATEX_ARTICLE_CONFIG)
	pandoc $(LATEX_DHHS_CONFIG) $(CWIS_INPUTS) \
	-o $(cwis_tex) \
  $(DHHS_PDF_FLAGS)

clean:
	rm -f *.pdf *.docx *.html
