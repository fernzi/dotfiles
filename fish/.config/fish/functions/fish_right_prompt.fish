function fish_right_prompt
  set_color black
  printf ''
  set_color -b black normal
  printf '%s ' (basename (string replace -r \^$HOME \~ $PWD))

  # Git status
  set_color -b brblack normal
  git status --porcelain=v2 --branch 2>/dev/null | awk '
    $1 == "#" && $2 == "branch.head" {
      printf "  %s ", $3
      git=1
    }
    $1~/1|2/ && $2~/[^.]./ {
      staged++
    }
    $1~/1|2/ {
      modified++
    }
    $1 == "?" {
      untracked++
    }
    END {
      if (git) {
        if (staged)
          printf "•%d ", staged
        if (modified)
          printf "+%d ", modified
        if (untracked)
          printf "~%d ", untracked
        if (!(staged || modified || untracked))
          printf "✔ "
      }
    }
  '

  set_color -b normal blue
  set_color -ro
  printf ' %s' $hostname
  set_color -b normal blue
  printf ''
  set_color normal
end
