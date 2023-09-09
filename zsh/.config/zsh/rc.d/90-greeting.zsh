#######################################################################
# Fern's Dotfiles -- Zsh - Startup Message
# https://github.com/fernzi/dotfiles
#######################################################################

# This is completely pointless and I love it.
# You'll take my text cat out of my cold, dead hands.

# Choose a random art file.
readonly artfile=(${ZSH_CONFIG}/art/*(-.oe[REPLY=\$RANDOM][1]))
readonly artlist=(${(@f)"$(<$artfile)"})
readonly maxline=$(wc -L <<< ${(F)artlist})
readonly colors=(red magenta blue green)

local padline=$(( ($COLUMNS - ($maxline + 2) * 4) / 2 + 1 ))

# Print the art file's content in four different colours,
# centered within the terminal's width.

for col in $colors; do
	print -nP "%F{$col}"
	printf "\e[${padline}C%s\n" $artlist
	printf '\e[%dA' ${#artlist}
	(( padline += $maxline + 2 ))
done

print -nPf '%s\e[%dB' '%f' ${#artlist}
