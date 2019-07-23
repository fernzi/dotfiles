function srihash -a url -d 'Calculate subresource integrity hash'
  set -q url[1] &&
  printf 'sha384-%s\n' (curl -sfL $url | openssl dgst -sha384 -binary | base64)
end
