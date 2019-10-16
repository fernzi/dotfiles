if command -qs firejail
  function killjail -d 'Shutdown a Firejail sandbox'
    firejail --list | fzy | cut -d: -f1 | xargs -ri firejail --shutdown={}
  end
end
