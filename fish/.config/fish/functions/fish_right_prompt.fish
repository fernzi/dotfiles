function fish_right_prompt
  set_color -b black
  printf ' %s ' (basename (string replace -r \^$HOME \~ $PWD))
  if git rev-parse --is-inside-work-tree &>/dev/null
    set -l gstaged (git diff-index --cached @ 2>/dev/null | wc -l)
    set -l gchanged (git diff-index --name-only @ 2>/dev/null | wc -l)
    set -l guntracked (git ls-files --exclude-standard --others | wc -l)
    set -l gstatus
    test $gstaged -gt 0 && set -a gstatus "●$gstaged"
    test $gchanged -gt 0 && set -a gstatus "+$gchanged"
    test $guntracked -gt 0 && set -a gstatus "¬$guntracked"
    set -q gstatus[1] || set gstatus '✓'
    set_color -r brblue
    printf ' %s %s ' (git rev-parse --abbrev-ref @ 2>/dev/null) "$gstatus"
  end
  set_color -r blue
  printf ' %s ' (hostname -s)
  set_color normal
end
