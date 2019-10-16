function passmenu -d 'Pick and copy password'
  gopass ls -f | fzy | xargs -ri gopass show -c {} $argv
end
