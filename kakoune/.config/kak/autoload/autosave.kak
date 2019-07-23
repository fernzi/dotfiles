################################################################################
# Autosave
################################################################################

### Options ####################################################################

declare-option -docstring 'autosave timer interval' \
  int autosave_interval 0

declare-option -docstring 'silence save notifications' \
  bool autosave_silent false

### Commands ###################################################################

define-command -hidden autosave-exec %{
  evaluate-commands %sh{
    if [ $kak_modified = true ]; then
      echo 'write'
      if [ $kak_opt_autosave_silent = false ]; then
        date '+echo -markup {Information}saved at %T'
      fi
    fi
  }
}

define-command -hidden autosave-trigger %{
  hook -once -group autosave window NormalIdle .* %{
    nop %sh{
      {
        sleep $kak_opt_autosave_interval
        echo "
          evaluate-commands -client $kak_client %{
            autosave-exec
            autosave-trigger
          }
        " | kak -p $kak_session
      } </dev/null >/dev/null 2>&1 &
    }
  }
}

### Hooks ######################################################################

hook global WinSetOption autosave_interval=[1-9]\d* %{
  hook -group autosave window FocusOut .* autosave-exec
  hook -group autosave window InsertEnd .* autosave-exec
  autosave-trigger
}

hook global WinSetOption autosave_interval=0 %{
  remove-hooks window autosave
}

################################################################################
