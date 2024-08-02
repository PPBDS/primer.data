library(tidyverse)

# read through all the other make_*.R files
# select the variables to keep
# select the rows to keep: arrest, sex, race, age, district, location, time
# rename variables
# transform the variables

x <- read_csv("data-raw/yg821jf8611_la_new_orleans_2020_04_01.csv.zip")

# Drop all zones without more than 1 observation.


# Using this code makes for an interesting time series:

# x |> count(date) |> arrange(n) |> ggplot(aes(x = date, y = n)) + geom_point()

# Not sure what to do with this?

# This makes clear why we need to delete the first 18 months of data.

#  x |> select(arrest_made, date) |> mutate(all = sum(arrest_made), .by = date) |> ggplot(aes(x = date, y = all)) + geom_point()
