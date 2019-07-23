function pgg -d 'Search processes'
  pgrep -f -- $argv | xargs -r ps -o pid,cmd --no-headers
end
