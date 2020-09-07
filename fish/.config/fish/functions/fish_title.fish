function fish_title
  printf '%s@%s - %s - ' $USER $hostname (status current-command)
  basename (string replace -r \^$HOME \~ $PWD)
end
