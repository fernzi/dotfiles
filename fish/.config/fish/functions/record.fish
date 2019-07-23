function record -a time -a filename -d 'Record screen'
  timeout -s SIGINT $time wf-recorder -f $filename -c h264_vaapi -p crf=0 -p preset=veryslow -t -d /dev/dri/renderD128 2> /dev/null
end
