function fish_greeting
  if command -qs fortune
    set_color -o red
    fortune -s
    set_color normal
  end
end
