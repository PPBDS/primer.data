library(tidycensus)
library(tidyverse)

variables <- c(
  "P1_001N",  # Total population
  "P1_003N",  # White alone
  "P1_004N",  # Black or African American alone
  "P1_006N",  # Asian alone
  "P2_002N",  # Hispanic or Latino
  "H1_001N"   # Total housing units
)

census_data <- get_decennial(
  geography = "block",
  variables = variables,
  state = "OK",
  county = "Cimarron",
  year = 2020,
  sumfile = "pl",
  output = "wide"
) |>

  rename(
    total_pop = P1_001N,
    white_alone = P1_003N,
    black_alone = P1_004N,
    asian_alone = P1_006N,
    hispanic_latino = P2_002N,
    total_housing = H1_001N
  )

write_csv(census_data, file = "data-raw/census.csv")
