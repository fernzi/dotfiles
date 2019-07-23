function up -a N -d 'Go up N directories'
  set N $N 1
  cd (string repeat -n $N[1] '../')
end
