function fish_greeting
  if command -qs fortune
    set_color -o ffbcd9
    fortune -s
    set_color normal
  end
end
