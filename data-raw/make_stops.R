library(tidyverse)
library(brms)

# read through all the other make_*.R files
# select the variables to keep
# select the rows to keep: arrest, sex, race, age, district, location, time
# SD: I felt that instead of both district & location, it would be better to hav the Police Zone
# rename variables
# transform the variables

x <- read_csv("data-raw/yg821jf8611_la_new_orleans_2020_04_01.csv.zip",
              guess_max = 100000, # needed b/c the default guesses the wrong coltypes, so it needs a bigger guess size.
              col_types = cols(date = col_date(format = ""), # still giving coltypes for the variable that we're using.
                               time = col_time(),
                               zone = col_character(),
                               subject_age = col_integer(),
                               subject_race = col_character(),
                               subject_sex = col_character(),
                               arrest_made = col_logical())) |>

# Selecting the variables specified at the top.

select(date, time, zone, # I wanted to keep date and time separate b/c something can be done with just the time.
       subject_age, subject_race,
       subject_sex, arrest_made) |>

# Renaming some variables so they're easier to use.

rename(age = "subject_age",
       sex = "subject_sex",
       race = "subject_race",
       arrested = "arrest_made") |>

# Drop all zones without more than 1 observation.

distinct()

# Checking whether any row includes the same value for every variable.

df <- x
df$unique <- !(duplicated(x) | duplicated(x, fromLast = TRUE))
df <- df |>
  filter(unique == FALSE)
stopifnot(nrow(df) == 0)

# Save.

stops <- x

usethis::use_data(stops, overwrite = TRUE)


# ------------------

# Using this code makes for an interesting time series:

# x |> count(date) |> arrange(n) |> ggplot(aes(x = date, y = n)) + geom_point()

# Not sure what to do with this?

# This makes clear why we need to delete the first 18 months of data.

#  x |> select(arrest_made, date) |> mutate(all = sum(arrest_made), .by = date) |> ggplot(aes(x = date, y = all)) + geom_point()

# SD: This would be better done in a tutorial rather than here

# ------------------
