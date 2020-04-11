function fish_title
  printf '%s@%s - %s - ' $USER (hostname -s) (status current-command)
  basename (string replace -r \^$HOME \~ $PWD)
end
