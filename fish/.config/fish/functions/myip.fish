# Fern's Dotfiles
# https://github.com/fernzi/dotfiles
# Find your publicly visible IP address

function myip -d 'Print public IP address'
	if command -q drill
		drill -Q @resolver1.opendns.com myip.opendns.com
	else if command -q dig
		dig +short @resolver1.opendns.com myip.opendns.com
	else
		curl -s https://icanhazip.com
	end
end
