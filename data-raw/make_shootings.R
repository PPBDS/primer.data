
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

x <- read_csv("data-raw/shootings.csv") |>
        select(-id) |>
        rename(mental_illness_signs = signs_of_mental_illness,
               weapon = armed) |>
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
               mental_illness_signs = if_else(mental_illness_signs == TRUE, "Yes", "No"),
               body_camera = if_else(body_camera == TRUE, "Yes", "No"))


# Full state names instead of abbreviations.

names <- read_csv("data-raw/fips_key.csv") |>
              select(-fips) |>
              rename(full_state = state,
                     state = state_abbr)

x %<>%
  left_join(names) |>
  select(-state) |>
  rename(state = full_state)


# Reorder variables and rows.

x %<>%
  select(name, date, state, city, manner_of_death:race, everything()) |>
  arrange(date, state, city, name)




# Save

shootings <- x

usethis::use_data(shootings, overwrite = T)


##############################################
#  Working on trying to access the FBI API   #
##############################################
#
# library(fbicrime)
# library(tidyverse)
# library(magrittr)
# library(janitor)
#
# # I am using the fbicrime package for accessing their API. It only returns
# # aggregated data, but that may also be interesting. For details, check out
# # https://medium.com/@wenjun.sarah.sun/an-r-wrapper-for-fbi-crime-api-a80f8586e0ffSet.
#
#
# # Step 1: Set an API key. Get one here: https://api.data.gov/signup/.
#
# set_fbi_crime_api_key('oW4EOrRT8o3WCvsFpREVRgpkcllcF0IqGarjmmo5')
#
#
# # Step 2: Get the data. The four argument must be used. For information on
# # possible inputs, see https://crime-data-explorer.app.cloud.gov/pages/docApi.
# # You can input multiple offenses at a time as a list, but only one variable. It
# # will likely return some errors if for some group there is no data available;
# # the data that exists will still be returned.
#
# state_race <- summarize_offender(offense = c('homicide',
#                                              'rape',
#                                              'arson'),
#                    level = 'states',
#                    level_detail = c('AL',	'AK',	'AZ',	'AR',	'CA',	'CO',
#                                     'CT',	'DE',	'FL',	'GA',	'HI',	'ID',
#                                     'IL',	'IN',	'IA',	'KS',	'KY',	'LA',
#                                     'ME',	'MD',	'MA',	'MI',	'MN',	'MS',
#                                     'MO',	'MT',	'NE',	'NV',	'NH',	'NJ',
#                                     'NM',	'NY',	'NC',	'ND',	'OH',	'OK',
#                                     'OR',	'PA',	'RI',	'SC',	'SD',	'TN',
#                                     'TX',	'UT',	'VT',	'VA',	'WA',	'WV',
#                                     'WI',	'WY'),
#                    variable = 'race') |>
#                    tibble() |>
#                    clean_names() |>
#                    mutate(race = unlist(key)) |>
#                    rename(state = level_detail,
#                           offense = type) |>
#                    select(year, state, offense, race, count)
#
# # Save this one. May create new data set from this.
#
# write_rds(state_race, "data-raw/state_race.rds")
#
# ##############################################

