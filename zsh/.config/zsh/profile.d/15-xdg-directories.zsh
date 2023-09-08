#######################################################################
# Fern's Dotfiles -- Zsh - XDG Base Directory Compatibility
# https://github.com/fernzi/dotfiles
#######################################################################

# Lotta programs just refuse to play nice,
# some with more reason than others.
# Can understand why things like SSH and GPG
# wouldn't change at this point, but does everything
# else need to dump their files into my home?

readonly conf="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly data="${XDG_DATA_HOME:-$HOME/.local/share}"
readonly cache="${XDG_CACHE_HOME:-$HOME/.cache}"

## Utilities ##########################################################

# Less
export LESSHISTFILE="${cache}/less.history"

# GNU Parallel
export PARALLEL_HOME="${conf}/parallel"

## Programming ########################################################

# Go
export GOPATH="${data}/go"

# Node
export NODE_REPL_HISTORY="${data}/node_history"
export NPM_CONFIG_USERCONFIG="${conf}/npm/npmrc"
export NVM_DIR="${data}/nvm"

# Python
export JUPYTER_CONFIG_DIR="${conf}/jupyter"
export IPYTHONDIR="${JUPYTER_CONFIG_DIR}"
export KERAS_HOME="${data}/keras"

# Ruby
export BUNDLE_USER_CONFIG="${conf}/ruby/bundle"
export BUNDLE_USER_CACHE="${cache}/ruby/bundle"
export BUNDLE_USER_PLUGIN="${data}/ruby/bundle"
export GEM_HOME="${data}/ruby/gem"
export GEM_SPEC_CACHE="${cache}/ruby/gem"

# Rust
export RUSTUP_HOME="${data}/rustup"
export CARGO_HOME="${data}/cargo"

## Games ##############################################################

# Firestorm Viewer
export FIRESTORM_USER_DIR="${data}/firestorm"
export FIRESTORM_X64_USER_DIR="${FIRESTORM_USER_DIR}"

# Nethack
export NETHACKOPTIONS="${conf}/nethack/nethackrc"
