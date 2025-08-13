library(tidyverse)

raw <- read_csv("data-raw/census.csv",
  col_types = cols(NAME = col_character(),
                   total_pop = col_integer(),
                   white = col_integer(),
                   black = col_integer(),
                   native_american = col_integer(),
                   asian = col_integer(),
                   pacific_islander = col_integer(),
                   hispanic_latino = col_integer()))

x <- raw |>
  select(NAME, total_pop, white, black, native_american,
    asian, pacific_islander, hispanic_latino) |>
  
  rename(name = "NAME") |>
  
  filter(total_pop > 0)
  
census <- x

usethis::use_data(census, overwrite = TRUE)
