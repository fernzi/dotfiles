function gitignore -d 'Generate .gitignore file'
  set -l langs (string join , $argv)
  curl -Ls "https://gitignore.io/api/$langs"
end
