library(tidyverse)

# This dataset is from Barfort, Klemmensen & Larsen (2019), and was originally
# used in a paper published in Political Science and Research Methods. Details
# of the study can be accessed at https://doi.org/10.1017/psrm.2019.63, the raw
# data used here is available at https://doi.org/10.7910/DVN/IBKYRX,

# Reading in the data. I excluded variables that indicate a candidate's middle
# name ("cand_middle"), and  whether a candidate was living at the time the study was
# conducted ("living"). Neither variable provides meaningful insights, and excluding
# them keeps the dataset concise. Next, I excluded variables that indicate the actual
# number of days a candidate lived before ("living_days_pre") and after the election
# ("living_days_post"). It makes little sense to include both the actual and the
# imputed version of these variables, so I decided to exclude the former. Also, I
# excluded variables indicating the annual population in a state ("pop_annual"), annual
# increases in per capita income ("pc_inc_ann"), total expenditures ("tot_expenditure"),
# and life expectancy of a candidate in remaining years ("ex"). These variables may be
# interesting, but have way too many NAs to be useful. Finally, I excluded four variables
# indicating the the census region in which an election took place ("reg_south", "reg_west",
# "reg_midwest", "reg_northeast"). This adds little information, given that we already have
# a variable indicating the federal state in which an election took place.

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
         third, female) %>%


  # Creating a new variable for sex, recoding the
  # 'party' variable.

  mutate(sex = case_when(
              female == 0 ~ "Male",
              female == 1 ~ "Female"),

         party = case_when(
              democrat == 1 ~ "Democrat",
              republican == 1 ~ "Republican",
              third == 1 ~ "Third party")) %>%


  # Recoding character variables.

  mutate(area = str_to_title(area),
         cand_first = str_to_title(cand_first),
         cand_last = str_to_title(cand_last),
         status = str_to_title(status)) %>%


  # Rearranging and getting rid of the leftover
  # variables.

  select(area, year, cand_first,
         cand_last, party, sex,
         death_date_imp, status,
         margin_pct_1, living_day_imp_post,
         living_day_imp_pre) %>%


  # Renaming some variables.

  rename(state = "area",
         first_name = "cand_first",
         last_name = "cand_last",
         died = "death_date_imp",
         win_margin = "margin_pct_1",
         alive_pre = "living_day_imp_pre",
         alive_post = "living_day_imp_post") %>%


  # Subsetting the data to only include observations for which the
  # date of death is known. This is the same as the authors have done
  # in the paper. The first condition drops all elections before 1945,
  # since for many elections before that year the date of death could
  # not be determined. The second condition then excludes all remaining
  # NAs in "died," most of which were caused by the recent elections
  # with many candidates not yet deceased.

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

