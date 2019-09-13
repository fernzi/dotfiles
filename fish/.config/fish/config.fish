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

set -x GOPATH ~/.local/share/go

set -x MOZ_ENABLE_WAYLAND 1
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1

set -x PARALLEL_HOME ~/.config/parallel
set -x LESSHISTFILE ~/.cache/less.history

set -x FIRESTORM_USER_DIR ~/.local/share/firestorm
set -x FIRESTORM_X64_USER_DIR $FIRESTORM_USER_DIR

source $__fish_config_dir/alias.fish 2> /dev/null

### Local #####################################################################

set -l lconfs \
  $__fish_config_dir/local.fish \
  $__fish_config_dir/local.$hostname.fish

for lconf in $lconfs
  source $lconf 2> /dev/null
end

###############################################################################
