################################################################################
# Fish Shell
################################################################################

set -l paths \
  $HOME/.local/bin

for path in $paths
  test -d $path && set -a fish_user_paths $path
end

for editor in kak nvim vim vi micro nano
  if type -q $editor
    set -x EDITOR $editor
    set -x VISUAL $editor
  end
end

test -f $__fish_config_dir/alias.fish && source $__fish_config_dir/alias.fish

set -x GOPATH ~/.local/share/go

### Local ######################################################################

set -l lconfs \
  $__fish_config_dir/local.fish \
  $__fish_config_dir/local.$hostname.fish

for lconf in $lconfs
  test -f $lconf && source $lconf
end

################################################################################
