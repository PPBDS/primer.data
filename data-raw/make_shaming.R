library(tidyverse)

# Citation:

# Gerber, Alan S., Donald P. Green, and Christopher W. Larimer, 2008,
# Replication Materials for “Social Pressure and Voter Turnout: Evidence from a
# Large-Scale Field Experiment.”
# http://hdl.handle.net/10079/c7507a0d-097a-4689-873a-7424564dfc82. ISPS Data
# Archive.

# See https://isps.yale.edu/research/data/d001 for lots of great details.
# Example:

# "Prior to random assignment we also removed households with the following
# characteristics: all members of the household had over a 60% probability of
# voting by absentee ballot if they voted or all household members had a greater
# than a 60% probability of choosing the Democratic primary rather than the
# Republican primary. Absentees were removed because it was thought that many
# would have decided to vote or not prior to receipt of the experimental
# mailings, which were sent to arrive just a few days before the election. Those
# considered overwhelmingly likely to favor the Democratic primary were excluded
# because it was thought that, given the lack of contested primaries, these
# citizens would tend to ignore pre election mailings. We removed everyone who
# lived in a route where fewer than 25 households remained, because the
# production process depended on using carrier-route-presort standard mail.
# Finally, we removed all those who had abstained in the 2004 general election
# on the grounds that those not voting in this very high turnout election were
# likely to be “deadwood”—those who had moved, died, or registered under more
# than one name."


x <- read_csv("data-raw/social_original.csv",
              col_types = cols(sex = col_character(),
                               yob = col_integer(),
                               p2002 = col_character(),
                               p2004 = col_character(),
                               g2002 = col_character(),
                               g2004 = col_character(),
                               treatment = col_character(),
                               voted = col_character(),
                               hh_size = col_integer(),
                               numberofnames = col_integer())) |>


  # Renaming variables. Remark: Don't be confused by only "Yes" in the 2004 general
  # election, as abstainers were removed by the researchers. This was an election
  # with a high turnout, so people who did not vote were likely to be "deadwood"
  # (dead, moved away, registered under several names) and would therefore have
  # falsified the results.

  rename(primary_00 = p2000,
         primary_02 = p2002,
         primary_04 = p2004,
         general_00 = g2000,
         general_02 = g2002,
         general_04 = g2004,
         neighbors = numberofnames) |>

  # We dropped hh_id since it seems (correctly?) to not have any information.
  # But might it not be related to geographic area, like cluster?

  select(-hh_id) |>

  # age seems like a much more handy variable than birth year . . .

  mutate(age = as.integer(2006 - yob)) |>

  # Make factor level order more convenient

  mutate(treatment = if_else(treatment == "Control", "No Postcard", treatment)) |>

  mutate(treatment = fct_relevel(treatment,
                                 c("No Postcard",
                                   "Civic Duty", "Hawthorne",
                                   "Self", "Neighbors"))) |>

  # Recoding character variables.

  mutate(sex = str_to_title(sex),
         primary_00 = str_to_title(primary_00),
         primary_02 = str_to_title(primary_02),
         primary_04 = str_to_title(primary_04),
         general_00 = str_to_title(general_00),
         general_02 = str_to_title(general_02),
         general_04 = str_to_title(general_04)) |>


  # Recoding voted as 0/1, makes later analysis much easier.

  mutate(primary_06 = ifelse(voted == "Yes", 1L, 0L)) |>

  # Note sure if these variables are useful, but want to keep them around. They
  # seem very suspicious to me. How can there be 98,212 with a value of 0.952381
  # for hh_general_04? And then 935 for 0.95? Should investigate this further.

  mutate(hh_primary_04 = p2004_mean) |>
  mutate(hh_general_04 = g2004_mean) |>

  # Should cluster be an integer or a character?

  mutate(cluster = as.character(cluster)) |>

  # Ordering variables.

  select(cluster, primary_06, treatment,
         sex, age,
         primary_00, general_00,
         primary_02, general_02,
         primary_04, general_04,
         hh_size, hh_primary_04, hh_general_04,
         neighbors)


# Test some items

stopifnot(nrow(x) == 344084)
stopifnot(all(unique(x$treatment) %in% c("No Postcard",
                                        "Civic Duty", "Hawthorne",
                                        "Self", "Neighbors")))

# Saving details

shaming <- x

usethis::use_data(shaming, overwrite = TRUE)



