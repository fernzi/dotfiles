if command -qs sv
  function svuser -w sv
    set -lx SVDIR ~/.config/runit/service
    if set -q XDG_CONFIG_HOME
      set SVDIR $XDG_CONFIG_HOME/runit/service
    end
    sv $argv
  end
end
