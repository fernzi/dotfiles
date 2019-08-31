###############################################################################
# Fish - Aliases
###############################################################################

if command -qs yay
  alias p yay
else if command -qs pacman
  alias p pacman
end

if command -qs xbps-install
  alias xi xbps-install
  alias xr xbps-remove
  alias xq xbps-query
  alias xp xbps-pkgdb
  alias xc xbps-reconfigure
end

###############################################################################
