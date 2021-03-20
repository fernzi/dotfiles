###############################################################################
# Fish - Aliases
###############################################################################

for pac in paru yay pacman
  if command -qs $pac
    alias p $pac
    break
  end
end

if command -qs xbps-install
  alias xi xbps-install
  alias xr xbps-remove
  alias xq xbps-query
  alias xp xbps-pkgdb
  alias xc xbps-reconfigure
end

alias e $EDITOR
