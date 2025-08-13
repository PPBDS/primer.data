library(tidycensus)
library(tidyverse)

variables <- c(
  "P1_001N",  # Total population
  "P1_003N",  # White alone
  "P1_004N",  # Black or African American alone
  "P1_005N",  # American Indian and Alaska Native alone
  "P1_006N",  # Asian alone
  "P1_007N",  # Native Hawaiian and Other Pacific Islander alone
  "P2_002N"   # Hispanic or Latino (of any race)
)

census_data <- get_decennial(
  geography = "county",
  variables = variables,
  state = NULL,
  year = 2020,
  sumfile = "pl",
  output = "wide"
) |>

  rename(
    total_pop = P1_001N,
    white = P1_003N,
    black = P1_004N,
    native_american = P1_005N,  # American Indian and Alaska Native
    asian = P1_006N,
    pacific_islander = P1_007N,  # Native Hawaiian and Other Pacific Islander
    hispanic_latino = P2_002N
  )

write_csv(census_data, file = "data-raw/census.csv")
