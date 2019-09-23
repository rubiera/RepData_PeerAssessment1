library(tidyverse)


#Code for reading in the dataset and/or processing the data

proj_data <- read_csv("./data/activity.csv")

head(proj_data)
class(proj_data)

mean(is.na(proj_data$steps))
#[1] 0.1311475

#Histogram of the total number of steps taken each day

#change interval to minute/seconds

head(proj_data$interval,30)
interval_whole <-strptime(str_pad(proj_data$interval,4,pad="0"), format='%M %S')
head(interval_whole,30)
class(interval_whole)

interval_min_sec <- substr(interval_whole,15,20)
head(interval_min_sec,30)
class(interval_min_sec)

date_time_paste <- paste(proj_data$date, interval_min_sec)
head(date_time_paste,30)
class(as.POSIXct(date_time_paste))
proj_date_time <- as.POSIXct(date_time_paste)
head(proj_date_time,30)

proj_data_cbind <- as_tibble(cbind(proj_data$steps, as.POSIXct(proj_date_time, tz = "")))
head(proj_data_cbind,100)
class(proj_data$steps)
class(proj_date_time)

proj_data_mutated <- mutate(proj_data,date_time = 
                              as.POSIXct(paste(proj_data$date, substr(interval_whole,15,20))))
head(proj_data_mutated,30)
nrow(proj_data_mutated)
proj_data_mutated_na_removed <- na.omit(proj_data_mutated)
head(proj_data_mutated_na_removed,30)
nrow(proj_data_mutated_na_removed)
(1-(15264/17568))
#[1] 0.1311475

ggplot(data = proj_data_mutated)+geom_path(mapping = aes(x=date_time, y=steps))+
  labs(x="Time", y = "Steps")+
  ggtitle("Steps across time")

ggplot(data = proj_data_mutated_na_removed)+geom_path(mapping = aes(x=date_time, y=steps))+
  labs(x="Time", y = "Steps")+
  ggtitle("Steps across time")

#Mean and median number of steps taken each day

proj_data_mean <- proj_data_mutated_na_removed %>% group_by(date) %>%
                                        summarize(mean = mean(steps))
ggplot(data = proj_data_mean)+geom_col(mapping = aes(x=date, y=mean))+
  labs(x="Time", y = "Mean Daily Steps")+
  ggtitle("Mean Daily Steps")

head(proj_data_mean)

# I need to ignore 0 values...
proj_data_median <- proj_data_mutated_na_removed %>% group_by(date) %>%
  summarize(median = median(steps[steps > 0]))
ggplot(data = proj_data_median)+geom_col(mapping = aes(x=date, y=median))+
  labs(x="Time", y = "Median Daily Steps")+
  ggtitle("Median Daily Steps
          \n (excluding intervals with steps = 0")

head(proj_data_median)

#Time series plot of the average number of steps taken





#The 5-minute interval that, on average, contains the maximum number of steps
#Code to describe and show a strategy for imputing missing data
#Histogram of the total number of steps taken each day after missing values are imputed
#Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
#All of the R code needed to reproduce the results (numbers, plots, etc.) in the report



