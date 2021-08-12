

library(tidyverse)
library(magrittr)
library(janitor)

# This data comes from the book crime by the numbers:
# https://github.com/jacobkap/crimebythenumbers/blob/master/data/shootings.csv
# It seems like the author originally took it from the FBIs Crime Data Explorer
# API, but I have not figured out how to use it yet. The data we have here is
# from 2015 to 2019, and it covers people who got shot by police officers. Not
# sure if we should include the names of the people who got shot, since it's
# somewhat irreverent, but also pretty interesting.

x <- read_csv("data-raw/shootings.csv") %>%
        select(-id) %>%
        rename(mental_illness_signs = signs_of_mental_illness,
               weapon = armed) %>%
        mutate(manner_of_death = case_when(manner_of_death == "shot" ~ "Shot",
                                           manner_of_death == "shot and Tasered" ~ "Shot and Tasered"),
               weapon = str_to_title(weapon),
               threat_level = str_to_title(threat_level),
               flee = str_to_title(flee),
               weapon = str_replace_all(weapon, c("And" = "and",
                                                  "Bb" = "BB",
                                                  "To Be" = "to be",
                                                  "Of" = "of")),

               age = as.integer(age),
               gender = case_when(gender == "F" ~ "Female",
                                  gender == "M" ~ "Male"),
               race = case_when(race == "A" ~ "Asian",
                                race == "B" ~ "Black",
                                race == "H" ~ "Hispanic",
                                race == "N" ~ "Other", # Not totally sure about this one. It seems that these abbreviations come from OMB, but their guidelines are confusing.
                                race == "O" ~ "Unknown",
                                race == "W" ~ "White"),
               mental_illness_signs = if_else(mental_illness_signs == "TRUE", 1, 0),
               body_camera = as.integer(body_camera))


# Full state names instead of abbreviations.

names <- read_csv("data-raw/fips_key.csv") %>%
              select(-fips) %>%
              rename(full_state = state,
                     state = state_abbr)

x %<>%
  left_join(names) %>%
  select(-state) %>%
  rename(state = full_state)


# Save

shootings <- x

usethis::use_data(shootings, overwrite = T)

