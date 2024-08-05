library(tidyverse)

# add comments
# college/colleges
# the .Rd




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

  filter(barrons != 9) |>

  # Renaming some variables

  rename(public = "type",
         tier = "barrons",
         enrollment = "ipeds_enrollment_2013",
         tuition = "sticker_price_2013",
         grad_rate = "grad_rate_150_p_2013",
         sat = "sat_avg_2013") |>


  # Editing selectivity, region and type to display text instead of numbers



  mutate(selectivity = case_when(tier == 1 ~ "Elite",
                                 tier == 2 ~ "Highly Selective",
                                 tier == 3 ~ "Moderately Selective",
                                 tier == 4 ~ "Lowly Selective",
                                 tier == 5 ~ "Lowly Selective",
                                 tier == 999 ~ "Non-selective")) |>

  mutate(tier = case_when(tier == 1 ~ 1,
                          tier == 2 ~ 2,
                          tier == 3 ~ 3,
                          tier == 4 ~ 4,
                          tier == 5 ~ 5,
                          tier == 999 ~ 6)) |>

  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West")) |>

  # Drop type
  # Changed it to be a binary (public or private)

  mutate(public = case_when(public == 1 ~ TRUE,
                            public == 2 ~ FALSE,
                            public == 3 ~ FALSE)) |>

  # Turning `hbcu` into a binary variable. Keep it.

  mutate(hbcu = case_when(hbcu == 0 ~ FALSE,
                          hbcu == 1 ~ TRUE)) |>

  # Keep cost by change to /10000

  mutate(tuition = tuition / 10000) |>

  drop_na()

x$selectivity <- factor(x$selectivity,
                        levels = c("Elite",
                                   "Highly Selective",
                                   "Moderately Selective",
                                   "Lowly Selective",
                                   "Non-selective"),
                        ordered = TRUE)
x$zip <- as.integer(x$zip)
x$tier <- as.integer(x$tier)
x$enrollment <- as.integer(x$enrollment)
x$region <- factor(x$region,
                   levels = c("Midwest",
                              "South",
                              "West",
                              "Northeast"))
x$sat <- as.integer(x$sat)

# Save.

college <- x

usethis::use_data(college, overwrite = TRUE)

