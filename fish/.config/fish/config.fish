###############################################################################
# Fish Shell
###############################################################################

set -l paths \
  $HOME/.local/bin

for path in $paths
  test -d $path && set -a fish_user_paths $path
end

for editor in kak nvim vim vi micro nano
  if type -q $editor
    set -x EDITOR $editor
    set -x VISUAL $editor
    break
  end
end

set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

set -x GOPATH ~/.local/share/go
set -x RUSTUP_HOME ~/.local/share/rustup
set -x CARGO_HOME ~/.local/share/cargo
set -x KERAS_HOME ~/.local/share/keras
set -x NPM_CONFIG_USERCONFIG ~/.config/npm/npmrc
set -x CCACHE_CONFIGPATH ~/.config/ccache/config
set -x CCACHE_DIR ~/.cache/ccache

set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
set -x XCOMPOSEFILE ~/.config/gtk-3.0/Compose

set -x PARALLEL_HOME ~/.config/parallel
set -x LESSHISTFILE ~/.cache/less.history
set -x LESS -R

if test -f ~/.config/lf/icons
  set -x LF_ICONS (sed 's/#.*$//' ~/.config/lf/icons | xargs printf '%s :')
end

set -x FIRESTORM_USER_DIR ~/.local/share/firestorm
set -x FIRESTORM_X64_USER_DIR $FIRESTORM_USER_DIR

if test $XDG_SESSION_DESKTOP != gnome
  set -x MOZ_ENABLE_WAYLAND 1
end

if test $XDG_SESSION_TYPE != wayland
  set -x GDK_SCALE 2
  set -x GDK_DPI_SCALE -1
end

source $__fish_config_dir/colors/terminal.fish 2>/dev/null
source $__fish_config_dir/alias.fish 2> /dev/null

### Local #####################################################################

set -l lconfs \
  $__fish_config_dir/local.fish \
  $__fish_config_dir/local.$hostname.fish

for lconf in $lconfs
  source $lconf 2> /dev/null
end

###############################################################################
