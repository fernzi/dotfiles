function myip -a mode -d 'Display external IP address'
  set -l opt
  switch $mode
    case 6
      set opt -6
    case 4
      set opt -4
  end
  dig $opt +short @resolver1.opendns.com ANY myip.opendns.com
end
