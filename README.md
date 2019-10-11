# Setup

1. Install [nvm][3]. Then, `nvm install node` will install the latest
   version. Or, do `nvm install <versaion>`. Use `nvm ls-remote` to
   find which versions are available for installation.
2. Update npm `npm install npm@latest -g`.
3. Install bower, `npm install -g bower `.
4. Goto `theme/feng/statis`, and install bower packages `bower install`.

# To build

1. `pelican -r content`
2. `make s3_upload` or `make github`.
3. `pandoc -s -V geometry:margin=1in --number-sections -V urlcolor=cyan --variable papersize=a4paper -t latex -o resume.pdf --latex-engine=xelatex resume.md`


Currently, it's on
[github](http://fengxia41103.github.com/myblog/). Love it.
