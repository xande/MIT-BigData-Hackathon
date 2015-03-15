---
title: "Tracking opinions around Ukraine"
author: "Alex Baranov"
date: "March 14, 2015"
output: html_document
---


```r
#setwd("~/MyDigilife/Labs/Hackathons/MIT-BigData-Hackathon")

d <- read.csv('output/results.csv')
d$date <- as.Date(d$date)
d$avg.sentiment <- (d$indico_sentiment + d$roseta_sentiment) / 2

str(d)
```

```
## 'data.frame':	41 obs. of  6 variables:
##  $ title           : Factor w/ 41 levels "BBC News - Boris Nemtsov Ukraine report 'to be released in April'",..: 5 22 1 36 11 25 2 29 10 3 ...
##  $ date            : Date, format: "2015-03-14" "2015-03-12" ...
##  $ url             : Factor w/ 41 levels "http://abcnews.go.com/Weird/wireStory/bowler-throws-grenade-ball-ukraine-injured-29610062",..: 3 19 10 4 36 38 31 20 33 1 ...
##  $ indico_sentiment: num  0.625 0.645 0.482 0.641 0.534 ...
##  $ roseta_sentiment: num  0.68 0.956 0.524 0.927 0.5 ...
##  $ avg.sentiment   : num  0.653 0.801 0.503 0.784 0.517 ...
```


```r
sentiment.avg <- aggregate(avg.sentiment ~ date, data = d, FUN = mean) 
sentiment.indico <- aggregate(indico_sentiment ~ date, data = d, FUN = mean) 
sentiment.roseta <- aggregate(roseta_sentiment ~ date, data = d, FUN = mean) 
```


### Indico's opinion around the topic

```r
plot(sentiment.indico)
abline(lm(indico_sentiment ~ date, data=sentiment.indico) )
av = mean(sentiment.indico$indico_sentiment)
abline(h=av, col="red")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

### Rosette's opinion around the topic

```r
plot(sentiment.roseta)
abline(lm(roseta_sentiment ~ date, data=sentiment.roseta) )
av = mean(sentiment.roseta$roseta_sentiment)
abline(h=av, col="green")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

### Avrage opinion

```r
plot(sentiment.avg)
abline(lm(avg.sentiment ~ date, data=sentiment.avg) )
av = mean(sentiment.avg$avg.sentiment)
abline(h=av, col="blue")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 
