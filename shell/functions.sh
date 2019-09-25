# Open a project in my own GitHub
ghopen() {
  open "https://github.com/ricardoruwer/${1}";
}

# Get the process on a given port
port() {
  lsof -i ":${1:-80}"
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
  local port="${1:-8000}"
  python -m SimpleHTTPServer "$port"
}

# Create a directory and cd to it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Determine size of a file or total size of a directory
fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* ./*;
  fi;
}

# Calculator
calc() {
  echo "$*" | bc -l;
}

# Weather
weather() {
  local LOCALE=$(echo ${LANG:-en} | cut -c1-2)
  if [ $# -eq 0 ]; then
    local LOCATION=$(curl -s ipinfo.io/loc)
  else
    local LOCATION=$1
  fi
  curl -s "$LOCALE.wttr.in/$LOCATION"
}
