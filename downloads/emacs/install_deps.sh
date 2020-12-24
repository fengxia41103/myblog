# org-roam needs this binary
install_pkg -x sqlite3 sqlite3
# Make sure there is a C compiler for emacsql-sqlite
[[ -n "$(which cc)" ]] || install_pkg -x cc clang

# Get a version of the PlantUML jar file.
install_pkg -x wget wget

URL='http://sourceforge.net/projects/plantuml/files/plantuml.jar/download'
DIR="${HOME}/Emacs"
if [[ ! -e "${DIR}/plantuml.jar" ]]; then
    [[ -d "${DIR}" ]] || mkdir -p "${DIR}"
    (cd "${DIR}" && wget -O plantuml.jar "${URL}")
    ls -l "${DIR}/plantuml.jar"
fi

# This can be used by helm-ag for faster grepping
install_pkg -x rg ripgrep

# helm-ag uses this for faster grepping
if [[ "$(uname)" == "Darwin" ]]; then
  install_pkg -x ag the_silver_searcher
else
  install_pkg -x ag silversearcher-ag
fi
