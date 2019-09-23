---
title: "Reproducible Research: Peer Assessment 1"
output: 
  html_document:
    keep_md: true
---





```r
library(tidyverse)
```

## Loading and preprocessing the data
I load the data into a variable named proj_data, and check the percent of NAs in the steps variable.


```r
proj_data <- read_csv("./data/activity.csv")
```

```
## Parsed with column specification:
## cols(
##   steps = col_double(),
##   date = col_date(format = ""),
##   interval = col_double()
## )
```

```r
head(proj_data)
```

```
## # A tibble: 6 x 3
##   steps date       interval
##   <dbl> <date>        <dbl>
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```

```r
class(proj_data)
```

```
## [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"
```

```r
mean(is.na(proj_data$steps))
```

```
## [1] 0.1311475
```

The data is in tibble format, which is the format I need to use the various functions available from tidyverse.


```r
interval_whole <-strptime(str_pad(proj_data$interval,4,pad="0"), format='%M %S')
proj_data_mutated <- mutate(proj_data,date_time = 
                              as.POSIXct(paste(proj_data$date, substr(interval_whole,15,20))))
head(proj_data_mutated)
```

```
## # A tibble: 6 x 4
##   steps date       interval date_time          
##   <dbl> <date>        <dbl> <dttm>             
## 1    NA 2012-10-01        0 2012-10-01 00:00:00
## 2    NA 2012-10-01        5 2012-10-01 00:05:00
## 3    NA 2012-10-01       10 2012-10-01 00:10:00
## 4    NA 2012-10-01       15 2012-10-01 00:15:00
## 5    NA 2012-10-01       20 2012-10-01 00:20:00
## 6    NA 2012-10-01       25 2012-10-01 00:25:00
```

```r
nrow(proj_data_mutated)
```

```
## [1] 17568
```

```r
proj_data_mutated_na_removed <- na.omit(proj_data_mutated)
head(proj_data_mutated_na_removed)
```

```
## # A tibble: 6 x 4
##   steps date       interval date_time          
##   <dbl> <date>        <dbl> <dttm>             
## 1     0 2012-10-02        0 2012-10-02 00:00:00
## 2     0 2012-10-02        5 2012-10-02 00:05:00
## 3     0 2012-10-02       10 2012-10-02 00:10:00
## 4     0 2012-10-02       15 2012-10-02 00:15:00
## 5     0 2012-10-02       20 2012-10-02 00:20:00
## 6     0 2012-10-02       25 2012-10-02 00:25:00
```

The percent of NA rows matches the difference in the original data and the data with NA values removed.


```r
nrow(proj_data_mutated)
```

```
## [1] 17568
```

```r
nrow(proj_data_mutated_na_removed)
```

```
## [1] 15264
```

```r
(1-(15264/17568))
```

```
## [1] 0.1311475
```

ggplot utomatically removes NAs. Here, I plot the distribution minus NAs, and it's exactly the same as the steps distribution with NAs.



```r
ggplot(data = proj_data_mutated_na_removed)+geom_path(mapping = aes(x=date_time, y=steps))+
  labs(x="Time", y = "Steps")+
  ggtitle("Steps across time")
```

![](PA1_template_files/figure-html/data time plot no na-1.png)<!-- -->

## What is mean total number of steps taken per day?

Here is the distribution of the mean number of steps taken per day.


```r
proj_data_mean <- proj_data_mutated_na_removed %>% group_by(date) %>%
                                        summarize(mean = mean(steps))
ggplot(data = proj_data_mean)+geom_col(mapping = aes(x=date, y=mean))+
  labs(x="Time", y = "Mean Daily Steps")+
  ggtitle("Mean Daily Steps")
```

![](PA1_template_files/figure-html/data mean-1.png)<!-- -->

Here is the distribution of the median number of steps taken per day for days with non-zero steps. The median for all days, including days with zero steps is zero for all days.


```r
proj_data_median <- proj_data_mutated_na_removed %>% group_by(date) %>%
  summarize(median = median(steps[steps > 0]))
ggplot(data = proj_data_median)+geom_col(mapping = aes(x=date, y=median))+
  labs(x="Time", y = "Median Daily Steps")+
  ggtitle("Median Daily Steps
          \n (excluding intervals with steps = 0")
```

![](PA1_template_files/figure-html/data median-1.png)<!-- -->



## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
