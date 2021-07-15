library(tidyverse)

# This dataset is from Barfort, Klemmensen & Larsen (2019), and was originally
# used in a paper published in Political Science and Research Methods. Details
# of the study can be accessed at https://doi.org/10.1017/psrm.2019.63, the raw
# data used here is available at https://doi.org/10.7910/DVN/IBKYRX.

# Reading in the data. I excluded variables that indicate a candidate's middle
# name ("cand_middle"), and  whether a candidate was living at the time the
# study was conducted ("living"). Neither variable provides meaningful insights,
# and excluding them keeps the dataset concise. Also, I excluded variables
# indicating annual increases in per capita income ("pc_inc_ann"), total
# expenditures ("tot_expenditure"), and life expectancy of a candidate in
# remaining years ("ex"). These variables may be interesting, but have way too
# many NAs to be useful. Finally, I excluded four variables indicating the the
# census region in which an election took place ("reg_south", "reg_west",
# "reg_midwest", "reg_northeast"). This adds little information, given that we
# already have a variable indicating the federal state in which an election took
# place.

# What is the `ex` variable? Looks interesting.

# Key variables are days lived before (living_day_imp_pre, living_day_pre) and
# after (living_day_imp_post, living_day_post) the election. Note that there are
# two versions of both, with one --- with "imp" in the name --- indicating that
# it has been imputed. They look highly similar, with a few less missing among
# the imputed. So, I will just use those, and out them into years rather than
# days for measurement.


# How accurate is this data? At random, I looked at Massachusetts and found two
# years (1908, 1909) with only one candidate (Republican Eben Draper). Yet,
# Wikipedia tells me that in 1908 and 1909 James H. Vahey ran against Draper.
# Indeed, in 1909, there was an Independence Party candidate, William Osgood,
# who got more than 5% of the vote. I have similar concerns about the 1854
# election in New York, where only 1 of the four candidates who got more than 5%
# of the vote is listed.  But there are (probably!) not enough omissions like
# this to change the results . . .

# Also, other data seems wrong. For example, David Williams, candidate for
# Governor in Kentucky in 2011 is listed with a death date of 2016-01-01, but
# Wikipedia lists him as alive. Other recent deaths check out. So, no worries?

x <- read_csv("data-raw/longevity.csv",
              col_types = cols(area = col_character(),
                               year = col_integer(),
                               cand_last = col_character(),
                               cand_first = col_character(),
                               party = col_character(),
                               death_date_imp = col_date(format = ""),
                               status = col_character(),
                               margin_pct_1 = col_double(),
                               living_day_imp_post = col_integer(),
                               living_day_imp_pre = col_integer(),
                               democrat = col_integer(),
                               republican = col_integer(),
                               third = col_integer(),
                               female = col_integer())) %>%


  # Selecting variables to be used.

  select(area, year, cand_last,
         cand_first, party,
         death_date_imp, status,
         margin_pct_1,
         living_day_imp_post,
         living_day_imp_pre,
         democrat, republican,
         third, female, reg_south,
         reg_west, reg_northeast, reg_midwest,
         pop_annual) %>%


  # Creating a new variable for sex. There are only 21 female governors left,
  # once we get done wih our restrictions.

  mutate(sex = case_when(female == 0 ~ "Male",
                         female == 1 ~ "Female")) %>%


  # VCreate the 'party' and 'region' variables. Is there are more elegant way to
  # handle this? The danger is that there are some observations with more than
  # one 1 and some with none. Using pivot_longer() would (?) be safer.

  mutate(party = case_when(democrat == 1 ~ "Democrat",
                           republican == 1 ~ "Republican",
                           third == 1 ~ "Third party")) %>%
  mutate(region = case_when(reg_south == 1 ~ "South",
                            reg_west == 1 ~ "West",
                            reg_northeast == 1 ~ "Northeast",
                            reg_midwest  == 1 ~ "Midwest")) %>%


  # Recoding character variables.

  mutate(area = str_to_title(area),
         cand_first = str_to_title(cand_first),
         cand_last = str_to_title(cand_last),
         status = str_to_title(status)) %>%


  # Rearranging and getting rid of the leftover variables.

  select(area, year, cand_first,
         cand_last, party, sex,
         death_date_imp, status,
         margin_pct_1, living_day_imp_post,
         living_day_imp_pre, region, pop_annual) %>%


  # Renaming some variables.

  rename(state = "area",
         first_name = "cand_first",
         last_name = "cand_last",
         died = "death_date_imp",
         win_margin = "margin_pct_1",
         population = "pop_annual",
         gender = "sex") %>%


  # years is a more natural measurement for later analysis. Right? Are these
  # good variable names?

  mutate(election_age = living_day_imp_pre / 365.25) %>%
  mutate(death_age = (living_day_imp_pre + living_day_imp_post) / 365.25) %>%
  mutate(lived_after = living_day_imp_post / 365.25) %>%

  select(-living_day_imp_pre, -living_day_imp_post) %>%


  # Subsetting the data to only include observations for which the
  # date of death is known. This is the same as the authors have done
  # in the paper. The first condition drops all elections before 1945,
  # since for many elections before that year the date of death could
  # not be determined. The second condition then excludes all remaining
  # NAs in "died," most of which were caused by the recent elections
  # with many candidates not yet deceased.s‚

  # Maybe I should keep everyone post 1945 . . .

  filter(year >= 1945, is.na(died) == FALSE) %>%


  # Arranging by state and year.

  arrange(state, year)


# Checking whether any row includes the same value for every
# variable.

df <- x
df$unique <- !(duplicated(x) | duplicated(x, fromLast = TRUE))
df <- df %>%
  filter(unique == FALSE)
stopifnot(nrow(df) == 0)


# Save.

governors <- x

usethis::use_data(governors, overwrite = TRUE)

