# To build

1. `pelican -r content`
2. `make s3_upload`
3. `pandoc -s -V geometry:margin=1in --number-sections -V urlcolor=cyan --variable papersize=a4paper -t latex -o resume.pdf --latex-engine=xelatex resume.md`
