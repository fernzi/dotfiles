function mkcd -w mkdir -d 'Create and change into directory'
  mkdir -pv $argv && cd $argv[-1]
end
