function color -a theme -d 'Change shell theme'
  set -l fishtheme "$__fish_config_dir/colors/$theme.fish"
  test -f $fishtheme && source $fishtheme
end
