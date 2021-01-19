#######################################################################
# Kakoune - Liteline
#######################################################################

declare-option -docstring 'enable fancy modeline' \
  bool liteline false

declare-option -docstring 'liteline section left cap' \
  str liteline_lcap ''

declare-option -docstring 'liteline section left cap' \
  str liteline_rcap ''

declare-option -docstring 'liteline internal separator' \
  str liteline_sep '▕ '

declare-option -hidden str liteline_fmt
declare-option -hidden str liteline_old
declare-option -hidden str liteline_face

# Faces ###############################################################

set-face global LitelineBase default,black
set-face global LitelineBaseSep black,default+r
set-face global LitelineBaseCap black,default
set-face global LitelineAlt default,bright-black
set-face global LitelineAltSep bright-black,default+r
set-face global LitelineAltCap bright-black,default
set-face global LitelineHigh white,default+rb
set-face global LitelineHighSep white,default+r
set-face global LitelineHighCap white,default

# Commands ############################################################

define-command -hidden -params 1.. liteline-add %{
  set-option -add window liteline_fmt "%arg{@}"
}

define-command -hidden -params 1 liteline-section-split %{
  set-option window liteline_face "%arg{1}"
  liteline-add " {Liteline%arg{1}} "
}

define-command -hidden liteline-sep %{
  liteline-add "{Liteline%opt{liteline_face}Sep}▕{Liteline%opt{liteline_face}} "
}

define-command -hidden -params 2 liteline-section %{
  liteline-add " {Liteline%arg{1}Cap}%opt{liteline_lcap}{Liteline%arg{1}}"
  set-option window liteline_face "%arg{1}"
  evaluate-commands "%arg{2}"
  liteline-add "{Liteline%opt{liteline_face}Cap}%opt{liteline_rcap}{Default}"
}

define-command -hidden liteline-build %{
  liteline-section Base %{
    # Cursor position
    liteline-add '%val{cursor_line}:%val{cursor_char_column}'

    # Percentual position
    liteline-section-split Alt
    liteline-add '%sh{
      printf "%s%%" $(($kak_cursor_line * 100 / $kak_buf_line_count))
    }'
  }

  liteline-section Base %{
    # FIXME: The face colours don't work quite right for these
    liteline-add '{{context_info}} {{mode_info}}'
  }

  liteline-section Base %{
    # File type
    liteline-add '%opt{filetype}'
    liteline-sep
    liteline-add '%opt{eolformat}'

    # Client & session
    liteline-section-split Alt
    liteline-add '%val{client} %val{session}'

    # Buffer name
    liteline-section-split High
    liteline-add %sh{printf '%s' "${kak_bufname##*/}"}
  }
}

# Hooks ###############################################################

hook global WinSetOption liteline=true %{
  set-option window liteline_fmt ''
  liteline-build
  set-option window liteline_old "%opt{modelinefmt}"
  set-option window modelinefmt "%opt{liteline_fmt}"
}

hook global WinSetOption liteline=false %{
  set-option window modelinefmt "%opt{liteline_old}"
}
