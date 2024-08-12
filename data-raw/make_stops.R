library(tidyverse)

# delete any zones with only 1 observation - DONE

# Drop the NAs since we don't want to bother students with this complexity.
# Note that this costs about 10,000 observations (the vast majority because of
# missing age) out of 400,000. It is a deep question whether or not we should
# drop these rows.
# SD: I say we keep the NAs b/c if we're trying to get an insight on the percent
# of people getting arrested, it would be useful to have that data.

# fix .R file, and then regenerate the help page - DONE

# Using a big guess_max because there are some weird values deep in the data.

raw <- read_csv("data-raw/yg821jf8611_la_new_orleans_2020_04_01.csv.zip",
                guess_max = 100000,
                col_types = cols(date = col_date(format = ""),
                                 time = col_time(),
                                 zone = col_character(),
                                 subject_age = col_integer(),
                                 subject_race = col_character(),
                                 subject_sex = col_character(),
                                 arrest_made = col_logical()))

# I wanted to keep date and time separate b/c something can be done with just
# the time.
# I felt that instead of both district & location, it would be better to have
# the Police Zone instead.

x <- raw |>
  select(date, time, zone,
         subject_age, subject_race,
         subject_sex, arrest_made) |>

  rename(age = "subject_age",
         sex = "subject_sex",
         race = "subject_race",
         arrested = "arrest_made") |>

  # Convenient if arrested is 0/1.

  mutate(arrested = if_else(arrested, 1L, 0L)) |>

  # There were 4 rows with NA dates. We get rid of them but we really ought to
  # check if any dates are missing.
  # Note that there were 0 NAs in the `arrested` column, so it made sense to
  # keep the NAs universally.

  drop_na(date) |>

  # Seems like there are almost no arrests for the first 18 months of the data.
  # By July 1, 2011, however, the value of arrested seems reasonable.

  filter(date >= "2011-07-01") |>

  # Delete any zones with only 1 observation - this was the easiest way I
  # found, but is there any better way?

  group_by(zone) |>
  filter(n() > 1) |>
  ungroup() |>

  # There are about 10,000 missing ages. They are reasonable spread out across
  # the time period.

  # x |> count(date, is.na(age)) |> filter(`is.na(age)`) |> ggplot(aes(y = n, x = date)) + geom_point()

  # Only 740 of the missing ages are associated with an arrest. This is about 8%
  # of all arrests. This is 4 times bigger than the 2% of all observations which
  # have a missing age. Why would it be that stops which result in an arrest are
  # 4 times more likely to be missing an age than stops which do not result in
  # an arrest? Good question. You can tell stories in which this is an important
  # discrepancy. But I can't imagine having students deal with this issue in a
  # tutorial. So, for now, we just delete all missing observations.

  drop_na()

# Save.

stops <- x

usethis::use_data(stops, overwrite = TRUE)
