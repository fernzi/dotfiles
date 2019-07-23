function play -a filename -d 'Play sound file'
  ffplay -nodisp -autoexit -loglevel quiet $filename > /dev/null
end
