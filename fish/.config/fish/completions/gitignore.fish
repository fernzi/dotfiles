function __fish_complete_gitignore
  if not set -q __fish_gitignore
    set -g __fish_gitignore (curl -Ls 'https://gitignore.io/api/list')
  end
  string split , $__fish_gitignore
end

complete -fc gitignore -a '(__fish_complete_gitignore)'
