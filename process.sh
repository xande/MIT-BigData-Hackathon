#!/bin/sh

ruby run_analysis.rb

Rscript -e "require(knitr); require(markdown); knit('visualize.Rmd', 'output/visualize.md');"
Rscript -e "require(knitr); require(markdown); markdownToHTML('output/visualize.md', 'results.html');"
Rscript -e "require(knitr); require(markdown); browseURL(paste('file://', file.path(getwd(),'results.html'), sep=''))"