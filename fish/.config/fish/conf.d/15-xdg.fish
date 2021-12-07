#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# Fish Shell - XDG Base Directory Compatibility
#######################################################################

status is-login || exit

# Lotta programs just refuse to play nice,
# some with more right than others.
# I mean, I can understand why SSH and GPG
# wouldn't change at this point, but,
# does everything need to dump their files in my home?

## Programming ########################################################

# Python/Jupyter
set -x JUPYTER_CONFIG_DIR ~/.config/jupyter
set -x IPYTHONDIR $JUPYTER_CONFIG_DIR
set -x KERAS_HOME ~/.local/share/keras

# Go
set -x GOPATH ~/.local/share/go

# Rust/Cargo
set -x RUSTUP_HOME ~/.local/share/rustup
set -x CARGO_HOME ~/.local/share/cargo

# Node
set -x NODE_REPL_HISTORY ~/.local/share/node_history
set -x NPM_CONFIG_USERCONFIG ~/.config/npm/npmrc
set -x NVM_DIR ~/.local/share/nvm

# CCache
set -x CCACHE_CONFIGPATH ~/.config/ccache/config
set -x CCACHE_DIR ~/.cache/ccache

# Ruby/Bundler
set -x BUNDLE_USER_CONFIG ~/.config/ruby/bundle
set -x BUNDLE_USER_CACHE ~/.cache/ruby/bundle
set -x BUNDLE_USER_PLUGIN ~/.local/share/ruby/bundle
set -x GEM_HOME ~/.local/share/ruby/gem
set -x GEM_SPEC_CACHE ~/.cache/ruby/gem

## Utilities ##########################################################

# Less
set -x LESSHISTFILE ~/.cache/less.history

# Pass
set -x PASSWORD_STORE_DIR ~/.local/share/password-store

# GNU Parallel
set -x PARALLEL_HOME ~/.config/parallel

## Games ##############################################################

# Firestorm
set -x FIRESTORM_USER_DIR ~/.local/share/firestorm
set -x FIRESTORM_X64_USER_DIR $FIRESTORM_USER_DIR

# Nethack
set -x NETHACKOPTIONS ~/.config/nethack/nethackrc
