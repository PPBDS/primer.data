library(tidyverse)

raw <- read_csv("data-raw/elections-poll-flsen-3.csv",
              col_types = cols(
                 response = col_character(),
                 educ = col_character(),
                 race_eth = col_character(),
                 gender = col_character(),
                 approve = col_character(),
                 region = col_character(),
                 turnout_score = col_number(),
                 final_weight = col_number(),
                 phone_type = col_character()))

x <- raw |>
  select(response, educ, race_eth, gender, approve, region, turnout_score, final_weight, phone_type) |>
  rename(
         education = "educ",
         race = "race_eth",
         sex = "gender"
  ) |>
  mutate(
    response = case_when(
      response == "Rep" ~ "Republican",
      response == "Dem" ~ "Democratic",
      TRUE ~ response
    ),
    approve = case_when(
      approve == "Disapp." ~ "Disapprove",
      approve == "Don't know" ~ "Do Not Know",
      TRUE ~ approve
    )
  )

polls <- x

usethis::use_data(polls, overwrite = TRUE)
