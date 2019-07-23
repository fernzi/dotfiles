function aurget -a pkg -a dir -d 'Fetch packages from AUR'
  if not set -q pkg[1]
    echo Package name not specified >&2
    return 1
  else if set -q dir
    git clone https://aur.archlinux.org/$pkg.git $dir
  else
    git clone https://aur.archlinux.org/$pkg.git
  end
end
