# MIT-BigData-Hackathon
Repository for the project created during MIT BigData Hackathon on March 14, 2015 (https://bigdatahackathon.wordpress.com/)

This project is a POC of Sentiment tracking around specific topic over time.

Sentiments are caluclated using [indico](http://indico.readme.io/v1.0/docs/sentiment) and [Rosette API)[http://www.basistech.com/text-analytics/rosette/]

#### Files

* run_analysis.rb - fetch, analyze and store results in CSV for further sentiment visualizations (don't forget to update API key prior to running the scripts!)
* visualize.Rmd - R markdown with visualization code
* process.sh - the script which automatically runs analysis, visualization and the opens results in a browser. 

#### Output
* output/results.csv - a sample of run_analysis.rb output
* results.html - a sample of visualized analysis

Sample output http://rpubs.com/xander/MIT-BigData-Sentiment-Analysis

