function pgg -d 'Search processes'
  pgrep -fi -- $argv | xargs -r ps -o pid,cmd --no-headers
end
