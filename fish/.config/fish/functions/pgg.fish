function pgg -d 'Search processes'
  pgrep -fi -- $argv | xargs -r ps -o pid,user,cmd --no-headers
end
