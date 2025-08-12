library(tidyverse)

raw <- read_csv("data-raw/census.csv",
  col_types = cols(NAME = col_character(),
                   total_pop = col_integer(),
                   white_alone = col_integer(),
                   black_alone = col_integer(),
                   asian_alone = col_integer(),
                   hispanic_latino = col_integer(),
                   total_housing = col_integer()))

x <- raw |>
  select(NAME, total_pop, white_alone, black_alone, 
    asian_alone, hispanic_latino, total_housing) |>
  
  rename(name = "NAME",
         white = "white_alone",
         black = "black_alone",
         asian = "asian_alone") |>
  
  filter(total_pop > 0) |>
  
   mutate(
    pct_white = round(white / total_pop * 100, 1),
    pct_black = round(black / total_pop * 100, 1),
    pct_asian = round(asian / total_pop * 100, 1),
    pct_hispanic = round(hispanic_latino / total_pop * 100, 1),
    
    people_per_housing = round(total_pop / total_housing, 1)
  ) |>
  
  mutate(
    # Population size groups
    pop_size = case_when(
      total_pop >= 100 ~ "Large (100+)",
      total_pop >= 25 ~ "Medium (25-99)", 
      TRUE ~ "Small (<25)"
    ),
    
    majority = case_when(
      pct_white > 50 ~ "White",
      pct_black > 50 ~ "Black",
      pct_hispanic > 50 ~ "Hispanic",
      pct_asian > 50 ~ "Asian",
      TRUE ~ "Mixed"
    )
  )

census <- x

usethis::use_data(census, overwrite = TRUE)
