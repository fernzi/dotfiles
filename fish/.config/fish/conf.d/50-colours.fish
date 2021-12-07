#######################################################################
# Fern's Dotfiles
# https://gitlab.com/fernzi/dotfiles
# Fish Shell - Terminal Based Colour Scheme
#######################################################################

status is-interactive || exit

set fish_color_normal            normal
set fish_color_command           magenta
set fish_color_quote             green
set fish_color_redirection       cyan
set fish_color_end               cyan
set fish_color_error             red
set fish_color_param             blue
set fish_color_comment           brblack -i
set fish_color_match             --bold
set fish_color_selection         white --bold --background=brblack
set fish_color_search_match      yellow --background=brblack
set fish_color_history_current   --bold
set fish_color_valid_path        --underline
set fish_color_operator          teal
set fish_color_escape            teal
set fish_color_cwd               normal
set fish_color_cwd_root          red
set fish_color_autosuggestion    brblack
set fish_color_user              normal
set fish_color_host              normal
set fish_color_host_remote       yellow
set fish_color_cancel            red -r
set fish_color_status            red

set fish_pager_color_prefix      white --underline
set fish_pager_color_completion
set fish_pager_color_description brblack
set fish_pager_color_progress    black --background=magenta
set fish_pager_color_secondary
