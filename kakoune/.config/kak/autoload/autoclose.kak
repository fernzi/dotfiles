################################################################################
# Closing Pairs
################################################################################

### Options ####################################################################

declare-option -docstring 'enable pair autoclosing' \
  bool autoclose false

declare-option -docstring 'pairs to auto close' \
  str-list autoclose_pairs ( ) { } [ ] \" \" \' \' ` `

### Commands ###################################################################

define-command -hidden -params 3 autoclose-ins-open %{
  try %{
    execute-keys -draft '<a-K>\w<ret>'
    execute-keys "%arg{2}"
    try %{
      execute-keys -draft '<a-k>..<ret>'
      execute-keys "<a-;>%arg{3}H"
    } catch %{
      execute-keys "<a-;>%arg{3}h"
    }
  }
}

define-command -hidden -params 3 autoclose-ins-clos %{
  evaluate-commands -save-regs '"^' %{
    try %{
      execute-keys -draft "<a-x><a-K>^\h*\Q%arg{2}\E$<ret>"
      execute-keys -draft -save-regs '' \
        "hF%arg{2}<a-k>\A\Q%arg{2}\E\s*\Q%arg{2}\E\z<ret>Z<a-;>;dz<a-:>lZ"
      try %{
        execute-keys -draft '<a-k>..<ret>'
        execute-keys '<a-;><a-z>u'
      } catch %{
        execute-keys '<a-;>z'
      }
    }
    echo
  }
}

define-command -hidden -params 3 autoclose-del-open %{
  try %{
    execute-keys -draft ";<a-k>\Q%arg{2}<ret>d"
  }
}

define-command -hidden -params 3 autoclose-del-clos %{
  try %{
    execute-keys -draft "h<a-k>\Q%arg{1}<ret>d"
  }
}

define-command -hidden autoclose-create-hooks %{
  evaluate-commands %sh{
    eval set -- $kak_quoted_opt_autoclose_pairs
    while [ $# -ge 2 ]; do
      echo "
        hook -group autoclose-insert window InsertChar %<\Q$1> %{
          autoclose-ins-open %<$1> %<$2> ${#2}
        }
        hook -group autoclose-insert window InsertDelete %<\Q$1> %{
          autoclose-del-open %<$1> %<$2> ${#2}
        }
      "
      if [ "$1" != "$2" ]; then
        echo "
          hook -group autoclose-insert window InsertChar %<\Q$2> %{
            autoclose-ins-clos %<$1> %<$2> ${#2}
          }
          hook -group autoclose-insert window InsertDelete %<\Q$2> %{
            autoclose-del-clos %<$1> %<$2> ${#2}
          }
        "
      fi
      shift 2
    done
  }
}

### Hooks ######################################################################

hook global WinSetOption autoclose=true %{
  autoclose-create-hooks
  hook -group autoclose-update window WinSetOption autoclose_pairs=.* %{
    remove-hooks window autoclose-insert
    autoclose-create-hooks
  }
}

hook global WinSetOption autoclose=false %{
  remove-hooks window autoclose-.+
}

################################################################################
