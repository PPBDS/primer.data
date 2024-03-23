library(tidyverse)
library(haven)
library(usethis)

# TOD0: modern versions of case_when() don't require NA_character_ nonsense, so
# this code can be simplified.

# This dataset is from the American National Election Survey (ANES), a project
# that aims to provide insights into voter behavior. ANES has been running since
# 1948 before and after each presidential election, and is run by academics at
# UMich and Stanford. The survey combines questions about voters' political
# attitudes with extensive biographical information, and has been expanded by a
# variety of issues over time. Details about ANES and the raw data can be found
# at:

# https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/.

# The raw zip is in the repo. Derived files are too big to commit. So, we just
# unzip, read and then delete. Should take a closer look at the code book.

# You would think that someone had already done this, but I can't find anything
# but this:

# https://github.com/jamesmartherus/anesr

unzip("data-raw/anes_timeseries_cdf_stata_20220916.zip")

raw_data <- read_dta("anes_timeseries_cdf_stata_20220916.dta")

stopifnot(all(file.remove(c("anes_timeseries_cdf_stata_20220916.dta",
                            "anes_timeseries_cdf_codebook_app_20220916.pdf",
                            "anes_timeseries_cdf_codebook_var_20220916.pdf"))))


x <- raw_data |>

  # Only retains presidential election years.

  filter(VCF0004 %in% seq(1948, max(raw_data$VCF0004), by = 4)) |>


  # Picking relevant variables: gender, income, year, race, party
  # identification, education, state FIPS code, voted in national elections?,
  # age group, incumbent president's approval, region, thermometer (blacks),
  # thermometer (whites), USA better off alone?, importance of religion, should
  # society of ensure equal opportunity?, people like R have say in government
  # actions,

  # Considering these variables as well.

  # VCF0701 REGISTERED TO VOTE PRE-ELECTION
  # VCF0702 DID RESPONDENT VOTE IN THE NATIONAL ELECTIONS
  # VCF0704 VOTE FOR PRESIDENT- MAJOR CANDIDATES
  # VCF0704a VOTE FOR PRESIDENT- MAJOR PARTIES
  # VCF0705 VOTE FOR PRESIDENT- MAJOR PARTIES AND OTHER
  # VCF0706 VOTE AND NONVOTE- PRESIDENT

  select(VCF0104, VCF0114, VCF0004,
         VCF0105a, VCF0301, VCF0140a,
         VCF0901a, VCF0702, VCF0102,
         VCF0450, VCF0112, VCF0206,
         VCF0207, VCF0823, VCF0846,
         VCF9013, VCF0613, VCF0704) |>


  # Renaming and cleaning gender variable.

  mutate(VCF0104 = as.character(as_factor(VCF0104))) |>

  separate(VCF0104, into = c(NA, "gender"),
           sep = "[.]") |>

  mutate(gender = case_when(
    gender == " Female" ~ "Female",
    gender == " Male" ~ "Male",
    gender == " Other (2016)" ~ "Other")) |>


  # Renaming and cleaning income variable. Note that recoding
  # the income percentiles as integers would be misleading,
  # like 1 for the lowest percentile group, 2 for the second
  # lowest etc. This makes people think that the differences
  # between each percentile group are the same, which is not
  # the case. A factor variable makes more sense here.

  mutate(VCF0114 = as.character(as_factor(VCF0114)))  |>

  separate(VCF0114, into = c(NA, "income"),
           sep = "[.]") |>

  mutate(income = as.factor(case_when(
    income == " 96 to 100 percentile" ~ "96 - 100",
    income == " 68 to 95 percentile" ~ "68 - 95",
    income == " 34 to 67 percentile" ~ "34 - 67",
    income == " 17 to 33 percentile" ~ "17 - 33",
    income == " 0 to 16 percentile" ~ "0 - 16"))) |>


  # Cleaning year variable.

  mutate(year = as.integer(VCF0004)) |>

  select(-VCF0004) |>


  # Filtering out all 1948 observations because they are
  # lacking data on several variables.

  filter(year > 1948) |>


  # Cleaning race variable.

  mutate(VCF0105a = as.character(as_factor(VCF0105a))) |>


  # I elected to use str_extract as the conditional test here because I
  # was getting an error where 'case_when()' would not allow a T/F test
  # on the LHS of the equation. I'm still looking into a workaround for
  # this, but this method does the job for now.

  mutate(race = as.character(case_when(
    str_extract(VCF0105a, pattern = "White") == "White" ~ "White",
    str_extract(VCF0105a, pattern = "Black") == "Black" ~ "Black",
    str_extract(VCF0105a, pattern = "Asian") == "Asian" ~ "Asian",
    str_extract(VCF0105a, pattern = "Indian") == "Indian" ~ "Native American",

    # I had to account for the 'non-hispanic' clause in the other labels, hence the
    # extra code in this case.

    # DK: That `== F` looks wrong . . .

    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == F) ~ "Hispanic",

    # This terminology has been used after the 1964 election.

    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "Other",

    # This terminology has been used until and including the 1964 election,
    # after which they described the respective group as "Other". In order
    # to avoid having two different terms for the same group of people in
    # different time periods, I decided to code this as "Other" as well.

    str_extract(VCF0105a,
                pattern = "Non-white") == "Non-white" ~ "Other",
                                                 TRUE ~ NA_character_))) |>


  # Dropping the leftover numeric race variable.

  select(-VCF0105a) |>


  # Cleaning ideology variable. This code is a mess! Must be an easier way. We
  # used to turn this into a number, from -3 to 3. But that should be done by
  # whomever uses the data, so we will just keep this as a factor, but with
  # levels in the correct order.

  mutate(VCF0301 = as_factor(VCF0301)) |>
  mutate(VCF0301 = as.character(VCF0301)) |>

  mutate(ideology = str_sub(VCF0301,
                            start = 4,
                            end = -1)) |>

  select(-VCF0301) |>

  # Whoah! Is there a weird bug in parse_factor? If you use parse_factor instead
  # of factor in the next line, the NA values get converted into another level,
  # which I am pretty sure should not be the default behavior.

  mutate(ideology = factor(ideology,
                           levels = c("Strong Democrat",
                                      "Weak Democrat",
                                      "Independent - Democrat",
                                      "Independent - Independent",
                                      "Independent - Republican",
                                      "Weak Republican",
                                      "Strong Republican"))) |>

  # Cleaning education variable.

  mutate(VCF0140a = as.character(as_factor(VCF0140a))) |>

  mutate(education = as.character(case_when(
    str_extract(VCF0140a, pattern = "1. ") == "1. " ~ "Elementary",
    str_extract(VCF0140a, pattern = "2. ") == "2. " ~ "Some Highschool",
    str_extract(VCF0140a, pattern = "3. ") == "3. " ~ "Highschool",
    str_extract(VCF0140a, pattern = "4. ") == "4. " ~ "Highschool +",

    # "Highschool +" indicates a HS diploma (or equivalent) plus additional,
    # non-academic training.

    str_extract(VCF0140a, pattern = "5. ") == "5. " ~ "Some College",
    str_extract(VCF0140a, pattern = "6. ") == "6. " ~ "College",
    str_extract(VCF0140a, pattern = "7. ") == "7. " ~ "Adv. Degree",
    TRUE ~ NA_character_))) |>


  # Converting education variable to a factor.

  mutate(education = factor(education,
                       levels = c("Elementary", "Some Highschool",
                                  "Highschool", "Highschool +",
                                  "Some College", "College",
                                  "Adv. Degree"))) |>


  # Dropping the leftover numeric education variable.

  select(-VCF0140a) |>


  # Cleaning state variable. Going from a haven_labelled object to an
  # integer is fun. If you fail to pass through <chr> state before going
  # to integer, the integrity of the values is lost for a presently unknown
  # reason. I recalled this as a workaround from a previous project and
  # it worked, I tested for coherence throughout and this was the first
  # method I arrived at that results in accurate data.

  mutate(fips = as.integer(as.character(VCF0901a))) |>


  # Dropping leftover state variable.

  select(-VCF0901a) |>

  # Cleaning/renaming region variable

  mutate(region = as.factor(case_when(VCF0112 == 1 ~ "Northeast",
                                      VCF0112 == 2 ~ "Midwest",
                                      VCF0112 == 3 ~ "South",
                                      VCF0112 == 4 ~ "West"))) |>

  # Dropping leftover region variable

  select(-VCF0112)


# Created a file with all fips codes and state abbreviations, based on info
# from https://www.nrcs.usda.gov/wps/portal/nrcs/detail/?cid=nrcs143_013696.
# Relevant .csv file included in `data-raw`.

fips_key <- read.csv("data-raw/fips_key.csv") |>

  select(fips, state_abbr)

# Ought to make this one pipe to make it easier to recreate.


# Creating a new dataframe by joining NES and key dataframes by
# fips codes.

z <- x |>
      left_join(fips_key, by = "fips") |>

  mutate(state = state_abbr) |>

  select(-fips, -state_abbr) |>


  # Cleaning voted variable. This is about voting in the election that occurred
  # this year. I *think* that ANES is always (?) conducted after election day.

  mutate(voted = as_factor(VCF0702)) |>

  separate(col = voted, into = c("voted", "v2"),
           sep = "[.]") |>

  mutate(voted = as.character(case_when(
             str_extract(v2, pattern = "voted") == "voted" ~ "Yes",
             str_extract(v2, pattern = "not") == "not" ~ "No",
             TRUE ~ NA_character_))) |>

  select(-VCF0702, -v2) |>


  # Cleaning age group variable.

  mutate(age = as_factor(VCF0102)) |>
  mutate(age = as.factor(case_when(
    str_detect(age, "1. ") == T ~ "17 - 24",
    str_detect(age, "2. ") == T ~ "25 - 34",
    str_detect(age, "3. ") == T ~ "35 - 44",
    str_detect(age, "4. ") == T ~ "45 - 54",
    str_detect(age, "5. ") == T ~ "55 - 64",
    str_detect(age, "6. ") == T ~ "65 - 74",
    str_detect(age, "7. ") == T ~ "75 +",
    TRUE ~ NA_character_))) |>

  select(-VCF0102) |>

  # Cleaning presidential approval variable. Need to find regex method
  # to automatize the process of using case_when.

  mutate(pres_appr = as_factor(VCF0450)) |>
  mutate(pres_appr = as.character(case_when(
    str_detect(pres_appr, "1. ") == T ~ "Approve",
    str_detect(pres_appr, "2. ") == T ~ "Disapprove",
    str_detect(pres_appr, "8. ") == T ~ "Unsure",
    TRUE ~ NA_character_))) |>

  select(-VCF0450) |>


  # Cleaning thermometer variables.

  mutate(therm_black = as.integer(VCF0206)) |>
  mutate(therm_white = as.integer(VCF0207)) |>
  select(-VCF0206, -VCF0207) |>


  # Cleaning variable on whether US would be better off
  # if unconcerned with rest of world.

  mutate(better_alone = as.character(as_factor(VCF0823)),
         better_alone = case_when(
           better_alone == "1. Agree (1956-1960: incl. 'agree strongly' and 'agree" ~ "Agree",
           better_alone == "2. Disagree (1956-1960: incl. 'disagree strongly' and" ~ "Disagree",
           TRUE ~ NA_character_)) |>
  select(-VCF0823) |>


  # Cleaning religious importance variable.

  mutate(religion = as.character(as_factor(VCF0846)),
         religion = case_when(
           religion == "1. Yes, important" ~ "Important",
           religion == "2. No, not important" ~ "Unimportant",
           religion == "8. DK" ~ "Don't know",
           TRUE ~ NA_character_)) |>
  select(-VCF0846) |>


  # Cleaning variable on whether society should ensure equal
  # opportunities to succeed.

  mutate(equality = as.character(as_factor(VCF9013)),
         equality = case_when(
           equality == "1. Agree strongly" ~ "Agree strongly",
           equality == "2. Agree somewhat" ~ "Agree somewhat",
           equality == "3. Neither agree nor disagree" ~ "Neither agree nor disagree",
           equality == "4. Disagree somewhat" ~ "Disagree somewhat",
           equality == "5. Disagree strongly" ~ "Disagree strongly",
           equality == "8. DK" ~ "Don't know",
           TRUE ~ NA_character_)) |>
  select(-VCF9013) |>

  # Cleaning variable on whether people like respondent have any
  # say in what the government does.

  mutate(influence = as.character(as_factor(VCF0613)),
         influence = case_when(
           influence == "1. Agree" ~ "Agree",
           influence == "2. Disagree" ~ "Disagree",
           influence == "3. Neither agree nor disagree (1988 and later only)" ~ "Neither agree nor disagree",
           TRUE ~ NA_character_))  |>
  select(-VCF0613) |>

  # Clean voting variable

  mutate(pres_vote = as.integer(VCF0704)) |>
  mutate(pres_vote = case_when(
    pres_vote == 1 ~ "Democrat",
    pres_vote == 2 ~ "Republican",
    pres_vote == 3 ~ "Third Party")) |>
  select(-VCF0704) |>


select(year, state, gender, income, age,
       education, race, ideology, voted,
       region, pres_appr, influence, equality,
       religion, better_alone, therm_black,
       therm_white, pres_vote)

# Check and save.

stopifnot(nrow(z) > 32000)
stopifnot(length(levels(z$education)) == 7)
stopifnot(is.integer(z$year))
stopifnot(dim(table(z$income)) == 5)


nes <- z

usethis::use_data(nes, overwrite = T)



