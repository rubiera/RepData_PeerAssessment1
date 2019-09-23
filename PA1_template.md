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

ggplot automatically removes NAs. Here, I plot the distribution minus NAs, and it's exactly the same as the steps distribution with NAs.


```r
ggplot(data = proj_data_mutated_na_removed)+geom_path(mapping = aes(x=date_time, y=steps))+
  labs(x="Time", y = "Steps")+
  ggtitle("Steps across time")
```

![](PA1_template_files/figure-html/data time plot no na-1.png)<!-- -->

ggplot automatically removes NAs. Here, I plot the distribution minus NAs, and it's exactly the same as the steps distribution with NAs. 


```r
proj_data_day_sum <- proj_data %>% group_by(date) %>%
      summarize(Sum.Steps = sum(steps))
ggplot(data = proj_data_day_sum, aes(x = date, y = Sum.Steps))+ 
  geom_bar(stat = "identity")+
  labs(x="Date", y = "Sum of Daily Steps")+
  ggtitle("Total Daily Steps")
```

![](PA1_template_files/figure-html/data-total-daily-steps-1.png)<!-- -->

The mean, excluding NAs, of the total steps per day is 10766.19.


```r
mean(na.omit(proj_data_day_sum$Sum.Steps))
```

```
## [1] 10766.19
```

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

As part of the exploration to answer this question, I have plotted the steps activity daily. 


```r
ggplot(data = proj_data_mutated)+
  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ date, nrow = 6)
```

![](PA1_template_files/figure-html/data daily average-1.png)<!-- -->

Here is the mean number of steps by 5 second interval for all days.


```r
proj_data_interval <- proj_data_mutated_na_removed %>% group_by(interval) %>%
  summarize(mean = mean(steps))
ggplot(data = proj_data_interval)+geom_line(mapping = aes(x=interval, y=mean))+
  labs(x="Time Interval", y = "Mean Daily Steps")+
  ggtitle("Mean Daily Steps by Time Interval
          \n in Seconds for Entire Day")
```

![](PA1_template_files/figure-html/data daily average by time interval-1.png)<!-- -->

The 5-minute interval that, on average, contains the maximum number of steps is found at 8 minutes and 35 seconds from the beginning of the day. The mean steps for this maximum interval is 206.


```r
filter(proj_data_interval, mean == max(mean))
```

```
## # A tibble: 1 x 2
##   interval  mean
##      <dbl> <dbl>
## 1      835  206.
```

## Imputing missing values
## Are there differences in activity patterns between weekdays and weekends?

I will answer the last two questions together. Actually, I want to answer them in the opposite order: I want to know the variations by day of the week and by separating the weekdays from the weekends, and then I want to carry out my imputation.


```r
proj_data_daysofweek <- mutate(proj_data_mutated,
  Day.of.Week = weekdays(as.POSIXct(date)))
Weekday <- c("Monday","Tuesday","Wednesday","Thursday","Friday")
Weekend <- c("Saturday","Sunday")
weekdays_weekend <- list(Weekday, Weekend)
factor(weekdays_weekend, levels = list(Weekday, Weekend))
```

```
## [1] c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
## [2] c("Saturday", "Sunday")                                  
## 2 Levels: c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday") ...
```

```r
proj_data_weekdays_only <- filter(proj_data_daysofweek,Day.of.Week %in% weekdays_weekend[[1]])
proj_data_weekdays_only <- mutate(proj_data_weekdays_only, Day.Type = c("Weekday"))
proj_data_weekend_only <- filter(proj_data_daysofweek,Day.of.Week %in% weekdays_weekend[[2]])
proj_data_weekend_only <- mutate(proj_data_weekend_only, Day.Type = c("Weekend"))
proj_data_factors <- rbind(proj_data_weekdays_only, proj_data_weekend_only)
head(proj_data_factors)
```

```
## # A tibble: 6 x 6
##   steps date       interval date_time           Day.of.Week Day.Type
##   <dbl> <date>        <dbl> <dttm>              <chr>       <chr>   
## 1     0 2012-10-02        0 2012-10-02 00:00:00 Monday      Weekday 
## 2     0 2012-10-02        5 2012-10-02 00:05:00 Monday      Weekday 
## 3     0 2012-10-02       10 2012-10-02 00:10:00 Monday      Weekday 
## 4     0 2012-10-02       15 2012-10-02 00:15:00 Monday      Weekday 
## 5     0 2012-10-02       20 2012-10-02 00:20:00 Monday      Weekday 
## 6     0 2012-10-02       25 2012-10-02 00:25:00 Monday      Weekday
```

Intervals by day of the week.


```r
ggplot(data = proj_data_factors)+
  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ Day.of.Week, nrow = 2)
```

![](PA1_template_files/figure-html/data-weekday-daily-average-1.png)<!-- -->

Intervals by if the day is a weekday or a weekend.


```r
ggplot(data = proj_data_factors)+
  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ Day.Type, nrow = 1)
```

![](PA1_template_files/figure-html/data-weekend-daily-average-1.png)<!-- -->

In order to impute NAs, I follow this procedure:

1. I separate proj_data_factors, which is the data I have been plotting, which includes NAs into two datasets: one with NAs, one without. 


```r
proj_data_factors_NA <- filter(proj_data_factors, 
                        is.na(proj_data_factors$steps) == TRUE)
nrow(proj_data_factors_NA)
```

```
## [1] 2304
```

```r
proj_data_factors_notNA <- filter(proj_data_factors, 
                               is.na(proj_data_factors$steps) == FALSE)
nrow(proj_data_factors_notNA)
```

```
## [1] 15264
```

```r
head(proj_data_factors_notNA)
```

```
## # A tibble: 6 x 6
##   steps date       interval date_time           Day.of.Week Day.Type
##   <dbl> <date>        <dbl> <dttm>              <chr>       <chr>   
## 1     0 2012-10-02        0 2012-10-02 00:00:00 Monday      Weekday 
## 2     0 2012-10-02        5 2012-10-02 00:05:00 Monday      Weekday 
## 3     0 2012-10-02       10 2012-10-02 00:10:00 Monday      Weekday 
## 4     0 2012-10-02       15 2012-10-02 00:15:00 Monday      Weekday 
## 5     0 2012-10-02       20 2012-10-02 00:20:00 Monday      Weekday 
## 6     0 2012-10-02       25 2012-10-02 00:25:00 Monday      Weekday
```


2. I then split the data that has no NA values into weekday data and weekend data.


```r
proj_data_factors_notNA_wday <- filter(proj_data_factors_notNA, Day.Type == "Weekday")
proj_data_factors_notNA_wend <- filter(proj_data_factors_notNA, Day.Type == "Weekend")                            
```

3. I calculate the mean steps for each time interval for the "no NA values" data separately for  weekday data and weekend data.

Here is the imputation distribution for weekdays.


```r
proj_data_notNA_wday_intervals <- proj_data_factors_notNA_wday %>% group_by(interval) %>%
                summarize(Mean.Interval = mean(steps))
ggplot(data=proj_data_notNA_wday_intervals)+geom_col(mapping = aes(x=interval, y=Mean.Interval))
```

![](PA1_template_files/figure-html/step-3-imp-dist-weekdays-1.png)<!-- -->

Here is the imputation distribution for weekends.


```r
proj_data_notNA_wend_intervals <- proj_data_factors_notNA_wend %>% group_by(interval) %>%
  summarize(Mean.Interval = mean(steps))
ggplot(data=proj_data_notNA_wend_intervals)+geom_col(mapping = aes(x=interval, y=Mean.Interval))
```

![](PA1_template_files/figure-html/step-3-imp-dist-weekends-1.png)<!-- -->

4. I use these distributions as the data I will impute. I assign the mean steps by interval from the "no NA values" weekday data to the weekday data with NA values for steps. I do the same for the weekend data by imputing weeking missing values with weekend modeled values from the mean steps in the "no NA values" weekend data.


```r
proj_data_factors_NA_wday <- filter(proj_data_factors_NA, Day.Type == "Weekday")
proj_data_factors_NA_wend <- filter(proj_data_factors_NA, Day.Type == "Weekend")

for (i in 1:seq_along(proj_data_notNA_wday_intervals$interval)) {
    proj_data_factors_NA_wday$steps <- proj_data_notNA_wday_intervals$Mean.Interval
}

for (i in 1:seq_along(proj_data_notNA_wend_intervals$interval)) {
  proj_data_factors_NA_wend$steps <- proj_data_notNA_wend_intervals$Mean.Interval
}

proj_data_final_imputed <- rbind(proj_data_factors_notNA,proj_data_factors_NA_wday,
                                 proj_data_factors_NA_wend)
```

5. I perform checks on the data to make sure the imputation makes sense. 


```r
proj_data_factors_NA_wday
```

```
## # A tibble: 1,440 x 6
##    steps date       interval date_time           Day.of.Week Day.Type
##    <dbl> <date>        <dbl> <dttm>              <chr>       <chr>   
##  1 2.08  2012-11-01        0 2012-11-01 00:00:00 Wednesday   Weekday 
##  2 0.462 2012-11-01        5 2012-11-01 00:05:00 Wednesday   Weekday 
##  3 0.179 2012-11-01       10 2012-11-01 00:10:00 Wednesday   Weekday 
##  4 0.205 2012-11-01       15 2012-11-01 00:15:00 Wednesday   Weekday 
##  5 0.103 2012-11-01       20 2012-11-01 00:20:00 Wednesday   Weekday 
##  6 0.615 2012-11-01       25 2012-11-01 00:25:00 Wednesday   Weekday 
##  7 0.718 2012-11-01       30 2012-11-01 00:30:00 Wednesday   Weekday 
##  8 1.18  2012-11-01       35 2012-11-01 00:35:00 Wednesday   Weekday 
##  9 0     2012-11-01       40 2012-11-01 00:40:00 Wednesday   Weekday 
## 10 2     2012-11-01       45 2012-11-01 00:45:00 Wednesday   Weekday 
## # ... with 1,430 more rows
```

```r
proj_data_factors_NA_wend
```

```
## # A tibble: 864 x 6
##    steps date       interval date_time           Day.of.Week Day.Type
##    <dbl> <date>        <dbl> <dttm>              <chr>       <chr>   
##  1 0.714 2012-10-01        0 2012-10-01 00:00:00 Sunday      Weekend 
##  2 0     2012-10-01        5 2012-10-01 00:05:00 Sunday      Weekend 
##  3 0     2012-10-01       10 2012-10-01 00:10:00 Sunday      Weekend 
##  4 0     2012-10-01       15 2012-10-01 00:15:00 Sunday      Weekend 
##  5 0     2012-10-01       20 2012-10-01 00:20:00 Sunday      Weekend 
##  6 6.21  2012-10-01       25 2012-10-01 00:25:00 Sunday      Weekend 
##  7 0     2012-10-01       30 2012-10-01 00:30:00 Sunday      Weekend 
##  8 0     2012-10-01       35 2012-10-01 00:35:00 Sunday      Weekend 
##  9 0     2012-10-01       40 2012-10-01 00:40:00 Sunday      Weekend 
## 10 0     2012-10-01       45 2012-10-01 00:45:00 Sunday      Weekend 
## # ... with 854 more rows
```


```r
ggplot(data=proj_data_factors_NA_wday)+geom_col(mapping = aes(x=interval, y=steps))
```

![](PA1_template_files/figure-html/imputation-check-weekdays-1.png)<!-- -->


```r
ggplot(data=proj_data_factors_NA_wend)+geom_col(mapping = aes(x=interval, y=steps))
```

![](PA1_template_files/figure-html/imputation-check-weekend-1.png)<!-- -->

I check that the total rows in the final, imputed data, is the same as the starting data.


```r
nrow(proj_data)
```

```
## [1] 17568
```

```r
nrow(proj_data_final_imputed)
```

```
## [1] 17568
```

I check the intervals by day of the week for the imputed data.


```r
ggplot(data = proj_data_final_imputed)+
  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ Day.of.Week, nrow = 2)
```

![](PA1_template_files/figure-html/final-imputation-check-weekdays-1.png)<!-- -->

I check the intervals by if the day is a weekday or a weekend for the imputed data.


```r
ggplot(data = proj_data_final_imputed)+
  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ Day.Type, nrow = 1)
```

![](PA1_template_files/figure-html/final-imputation-check-weekends-1.png)<!-- -->

Finally, I draw the day by day plot and see that NA weekdays have been imputed and that NA weekends have been imputed. The means for the imputations are lower than the typical day because there are days with complete data (no NAs) with very small step counts, such as Oct 2, and Nov 15. In a more sophisticated imputation, I would have excluded those two days from my reference distribution to use as the data to assign to the NA days.


```r
baseplot <- ggplot(data = proj_data_final_imputed)
baseplot +  geom_line(mapping = aes(x = interval, y = steps))+
  facet_wrap(~ date, nrow = 6)
```

![](PA1_template_files/figure-html/final-daily-imputation-check-1.png)<!-- -->

