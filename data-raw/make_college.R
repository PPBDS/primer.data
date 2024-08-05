library(tidyverse)

# add comments. Added a few from out convo today and yesterday
# college/colleges: going with college
# the .Rd


# Zip code may not be necessary, since we already have 2 other location variables, county and state.
# It seems as if there are probably not many colleges per county, so removing zip might be a good idea.

# There doesnt seem to be much of a relationship between grad_rate and tuition for
# the schools which charge less than 20k per year, will filter them out during the EDA

# Historically Black Colleges overall had an impact on graduation rate,
# however, once we filter them out to ones where tuition is 20k+, the number of hbcu's goes fom 40 -> 7

# Selectivity seems to affect graduation rate a ton

# Will show a basic scatterplot in the EDA where tuition is on x-axis and grad_rate is on y

# One college has a graduation rate of 3%, Bacone College which dissolved in 2018. Is it worth keeping it in our data?

x <- read_csv("data-raw/mrc_table10.csv") |>

  # selecting variables to be used

  select(name,
         region,
         state,
         county,
         zip,
         type,
         barrons,
         hbcu,
         ipeds_enrollment_2013,
         sticker_price_2013,
         grad_rate_150_p_2013,
         sat_avg_2013) |>

  # Removing 'special' colleges since there are only 5 of them

  filter(barrons != 9) |>

  # Renaming some variables

  rename(public = "type",
         tier = "barrons",
         enrollment = "ipeds_enrollment_2013",
         tuition = "sticker_price_2013",
         grad_rate = "grad_rate_150_p_2013",
         sat = "sat_avg_2013") |>


  # Editing selectivity, region and type to display text instead of numbers


  # selectivity is just tier, tier might not even be necessary since we are turning it into selectivity
  mutate(selectivity = case_when(tier == 1 ~ "Elite",
                                 tier == 2 ~ "Highly Selective",
                                 tier == 3 ~ "Moderately Selective",
                                 tier == 4 ~ "Lowly Selective",
                                 tier == 5 ~ "Lowly Selective",
                                 tier == 999 ~ "Non-selective")) |>

  # Changing tier fom 999 to 6 so that it looks better when ordered

  mutate(tier = case_when(tier == 1 ~ 1,
                          tier == 2 ~ 2,
                          tier == 3 ~ 3,
                          tier == 4 ~ 4,
                          tier == 5 ~ 5,
                          tier == 999 ~ 6)) |>

  # easier to interpret

  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West")) |>

  # Drop type
  # Changed it to be a binary (public or private)

  mutate(public = case_when(public == 1 ~ TRUE,
                            public == 2 ~ FALSE,
                            public == 3 ~ FALSE)) |>

  # Turning `hbcu` into a true/false variable.

  mutate(hbcu = case_when(hbcu == 0 ~ FALSE,
                          hbcu == 1 ~ TRUE)) |>

  # Keep cost by change to / 10000

  mutate(tuition = tuition / 10000) |>

  drop_na()


# Ordering factors for selectivity
# This being an ordered factor makes it harder to interpret the regression coefficients,
# might have to make it a normal factor

x$selectivity <- factor(x$selectivity,
                        levels = c("Elite",
                                   "Highly Selective",
                                   "Moderately Selective",
                                   "Lowly Selective",
                                   "Non-selective"),
                        ordered = TRUE)

# Turning these into integers
x$zip <- as.integer(x$zip)
x$tier <- as.integer(x$tier)
x$enrollment <- as.integer(x$enrollment)
x$sat <- as.integer(x$sat)

# Turning region into a factor

x$region <- factor(x$region,
                   levels = c("Midwest",
                              "South",
                              "West",
                              "Northeast"))

# Save.

college <- x
usethis::use_data(college, overwrite = TRUE)

