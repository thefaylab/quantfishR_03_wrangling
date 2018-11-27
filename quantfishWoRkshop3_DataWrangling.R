#########################################################################################################
### Data wrangling (Part 1) - Getting your data the way you want it
## Largely follows the 'R for Data Science' book, Chapter 5 - Data Transformation
## quantfish woRkshop 3
## 11/27/18
#########################################################################################################
## Load packages/dataset for today
library(tidyverse)
library(nycflights13)

## What does this dataset look like?
flights
View(flights)

##########################################################################
## Filter rows with filter( )
filter(flights, month == 1, day == 1)
# Save as a new tibble
jan1 <- filter(flights, month == 1, day == 1)
# Save as a new tibble and print
(jan1 <- filter(flights, month == 1, day == 1))

## Comparisons
# What happens if we don't use '=='?
filter(flights, month = 1)
# When filtering based on an operation, use near() because of floating point numbers
sqrt(2) ^ 2 == 2
# vs
near(sqrt(2) ^ 2, 2)

## Logical operators - see slide for an overview
filter(flights, month == 11 | month == 12) # Select flights that departed in Nov and Dec
# or
filter(flights, month %in% c(11, 12)) # This will be more concise if you want to include more than 2 levels

## Identifying and excluding missing values
is.na(flights) # whole dataset
is.na(flights$dep_delay) # specific column

# How many have an 'NA' value for departure delay?
filter(flights, is.na(dep_delay))
# How many have values for departure delay?
filter(flights, !is.na(dep_delay))

## Identifying and excluding duplicate rows
distinct(flights) # based on all columns
distinct(flights, flight) # based on one column
distinct(flights, flight, .keep_all=TRUE) # based on one column but keeping all columns

##########################################################################
## Sort rows with arrange( )
arrange(flights, dep_delay)

## Sort in descending order
arrange(flights, desc(dep_delay))

## Sort multiple rows, some in ascending and some in descending order
arrange(flights, year, month, day)
arrange(flights, year, desc(month), day)

##########################################################################
## Select columns with select( )
select(flights, year, month, day) # by name
select(flights, year:day) # between certain columns

# Omit certain columns
select(flights, -(year:day))

# Move columns to the front of your dataset but keep all other variables as well
select(flights, time_hour, air_time, everything())

# Create a new tibble 
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)

##########################################################################
## Add new variables with mutate( )
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)

# You can refer to newly-created variables within the call
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

# If you only want to keep the new variables, use transmute()
transmute(flights_sml,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)

##########################################################################
## Combining multiple operations with the pipe
## Instead of this (clunky)
flights_sml <- select(flights,
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)

flights_sub <- mutate(flights_sml,
                      gain = dep_delay - arr_delay,
                      hours = air_time / 60,
                      gain_per_hour = gain / hours)

## We can acheive the same thing by doing this
flights_sub <- flights %>%
               select(year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time) %>%
               mutate(gain = dep_delay - arr_delay,
                      hours = air_time / 60,
                      gain_per_hour = gain / hours) %>% # ctrl + shift + M is a shortcut for the pipe
               print # will print out your new dataset so you can look at without having to re-enter
  
