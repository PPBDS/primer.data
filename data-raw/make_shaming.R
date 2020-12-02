library(tidyverse)

# This dataset is from Gerber, Green & Larimer (2008), and was originally
# published as part of a study in the American Political Science Review.
# The raw data and details of the study can be accessed at
# https://isps.yale.edu/research/data/d001.

# Reading in the data. I excluded variables that represent internal IDs the
# researchers assigned to households ("hh_id") and clusters of randomization
# ("cluster"), as well as variables that show the mean voter turnout per
# household in the 2004 elections ("p2004_mean" and "g2004_mean"). None of
# these are particularly relevant for analyzing and interpreting the data.
# Furthermore, I also excluded two variables that show the voting histories
# of the 2000 elections ("p2000" and "g2000"). They provide little insight in
# addition to the remaining histories from 2002 and 2004, and we do not want
# to overwhelm people.

x <- read_csv("data-raw/social_original.csv",
              col_types = cols(sex = col_character(),
                               yob = col_integer(),
                               p2002 = col_character(),
                               p2004 = col_character(),
                               g2002 = col_character(),
                               g2004 = col_character(),
                               treatment = col_factor(),
                               voted = col_character(),
                               hh_size = col_integer(),
                               numberofnames = col_integer())) %>%


  # Renaming variables. Remark: Don't be confused by only "Yes" in the 2004 general
  # election, as abstainers were removed by the researchers. This was an election
  # with a high turnout, so people who did not vote were likely to be "deadwood"
  # (dead, moved away, registered under several names) and would therefore have
  # falsified the results.

  rename(birth_year = yob,
         primary_02 = p2002,
         primary_04 = p2004,
         general_02 = g2002,
         general_04 = g2004,
         no_of_names = numberofnames) %>%


  # Recoding character variables.

  mutate(sex = str_to_title(sex),
         primary_02 = str_to_title(primary_02),
         primary_04 = str_to_title(primary_04),
         general_02 = str_to_title(general_02),
         general_04 = str_to_title(general_04)) %>%


  # Recoding voted as 0/1, makes later analysis much easier.

  mutate(primary_06 = ifelse(voted == "Yes", 1L, 0L)) %>%


  # Recoding no_of_names to be NA for every treatment group
  # except neighbors. The number has no meaning for all other
  # groups, and removing them avoids confusion.

  mutate(no_of_names = ifelse(treatment != "Neighbors",
                               NA_integer_, no_of_names)) %>%


  # Ordering variables.

  select(sex, birth_year,
         primary_02, general_02,
         primary_04, general_04,
         treatment, primary_06,
         hh_size, no_of_names)


# Save.

shaming <- x

usethis::use_data(shaming, overwrite = TRUE)



