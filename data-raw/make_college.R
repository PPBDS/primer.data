library(tidyverse)



x <- read_csv("data-raw/mrc_table10.csv") |>

  # selecting variables to be used

  select(name,
         region,
         state,
         county,
         zip,
         tier,
         tier_name,
         type,
         iclevel,
         barrons,
         hbcu,
         ipeds_enrollment_2013,
         sticker_price_2013,
         grad_rate_150_p_2013,
         avgfacsal_2013,
         sat_avg_2013,
         asian_or_pacific_share_fall_2000,
         black_share_fall_2000,
         hisp_share_fall_2000,
         alien_share_fall_2000,
         pct_arthuman_2000,
         pct_business_2000,
         pct_health_2000,
         pct_multidisci_2000,
         pct_publicsocial_2000,
         pct_stem_2000,
         pct_tradepersonal_2000,
         pct_socialscience_2000) |>

# Renaming some variables

  rename(degree_offering = "iclevel",
         selectivity = "barrons",
         enrollment = "ipeds_enrollment_2013",
         cost = "sticker_price_2013",
         grad_rate = "grad_rate_150_p_2013",
         faculty_sal = "avgfacsal_2013",
         sat = "sat_avg_2013",
         pct_asian_pacific = "asian_or_pacific_share_fall_2000",
         pct_black = "black_share_fall_2000",
         pct_hispanic = "hisp_share_fall_2000",
         pct_international = "alien_share_fall_2000",
         pct_arthuman = "pct_arthuman_2000",
         pct_business = "pct_business_2000",
         pct_med = "pct_health_2000",
         pct_multidisci = "pct_multidisci_2000",
         pct_publicsocial = "pct_publicsocial_2000",
         pct_stem = "pct_stem_2000",
         pct_socialscience = "pct_socialscience_2000",
         pct_tradepersonal = "pct_tradepersonal_2000") |>

# Creating a new variable `acceptance_rate`.

# Editing selectivity, degree_offering, region and type to display text instead of numbers

  mutate(selectivity = case_when(selectivity == 1 ~ "Elite",
                                 selectivity == 2 ~ "Highly Selective",
                                 selectivity == 3 ~ "Selective",
                                 selectivity == 4 ~ "Moderately Selective",
                                 selectivity == 5 ~ "Moderately Selective",
                                 selectivity == 9 ~ "Special",
                                 selectivity == 999 ~ "Non-selective")) |>

  mutate(degree_offering = case_when(degree_offering == 1 ~ "Four-year",
                                     degree_offering == 2 ~ "Two-year",
                                     degree_offering == 2 ~ "Less than two-year")) |>

  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West")) |>

  mutate(type = case_when(type == 1 ~ "public",
                          type == 2 ~ "private non-profit",
                          type == 3 ~ "private for-profit")) |>

# Turning `hbcu` into a binary variable

  mutate(hbcu = case_when(hbcu == 0 ~ FALSE,
                          hbcu == 1 ~ TRUE))


