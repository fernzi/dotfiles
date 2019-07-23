function bibget -a PDF -d 'Search BibTeX references'
  set -l DOI $PDF
  if test -f "$PDF"
    set DOI (pdfinfo $PDF 2>/dev/null | grep -io 'doi:.*' ||
             pdftotext $PDF - 2>/dev/null | grep -m 1 -io 'doi:.*')
  end
  curl -s "http://api.crossref.org/works/$DOI/transform/application/x-bibtex"
end
