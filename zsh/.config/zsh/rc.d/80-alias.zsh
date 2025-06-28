#######################################################################
# Fern's Dotfiles -- Zsh - Command Aliases
# https://github.com/fernzi/dotfiles
#######################################################################

local cmd

# Debian installs `fd` as `fdfind` cause of a name clash.
# This `fd` is one of the few UNIX utils replacements that's
# actually useful, so I don't mind shadowing that other one.
if [[ -v commands[fdfind] ]]; then
	alias fd=fdfind
fi

# I don't really keep up with the flavour of the month
# AUR helper, so which ones and in which order this checks
# is kind of arbitrary.
for cmd in yay paru pacman; do
	if [[ -v commands[${cmd}] ]]; then
		alias p=${cmd}
		break
	fi
done

# If the cost of not creating untracked files
# is defining an alias, I'll gladly pay it.
if [[ -v commands[corepack] ]]; then
  for cmd in npm npx pnpm pnpx; do
    alias ${cmd}="corepack ${cmd}"
  done
fi

# Gentoo installs upstream 7zip as `7zz` as to not conflict
# with p7zip, I imagine. Problem is p7zip is kinda dead.
if [[ -v commands[7zz] ]]; then
  alias 7z=7zz
fi
