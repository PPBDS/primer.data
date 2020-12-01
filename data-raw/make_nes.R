
library(tidyverse)
library(haven)
library(usethis)


# This dataset is from the American National Election Survey (ANES), a project
# that aims to provide insights into voter behavior. ANES has been running since
# 1948 before and after each presidential election, and is run by academics at
# UMich and Stanford. The survey combines questions about voters' political
# attitudes with extensive biographical information, and has been expanded by a
# variety of issues over time. Details about ANES and the raw data can be found
# at https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/.

# Reading in the data. The raw data file is too big to include in the repo,
# so it was added to .gitignore. Before being able to make changes to the 'nes'
# dataset, you must download the dataset using the above link and move it to
# /data-raw.

data <- read_dta("data-raw/anes_timeseries_cdf.dta")


# Filters only for presidential years to the end of the data.

pres_years <- seq(1948, max(data$VCF0004), by = 4)

x <- data %>%

  # Only retains presidential election years.

  filter(VCF0004 %in% pres_years) %>%


  # Picking relevant variables: gender, income, year,
  # race, party identification, education, state FIPS
  # code, voted in national elections?, age group,
  # incumbent president's approval, region

  select(VCF0104, VCF0114, VCF0004,
         VCF0105a, VCF0301, VCF0140a,
         VCF0901a, VCF0702, VCF0102,
         VCF0450, VCF0112) %>%


  # Renaming and cleaning gender variable.

  mutate(VCF0104 = as.character(as_factor(VCF0104))) %>%

  separate(VCF0104, into = c(NA, "gender"),
           sep = "[.]") %>%

  mutate(gender = case_when(
    gender == " Female" ~ "Female",
    gender == " Male" ~ "Male",
    gender == " Other (2016)" ~ "Other")) %>%


  # Renaming and cleaning income variable. Note that recoding
  # the income percentiles as integers would be misleading,
  # like 1 for the lowest percentile group, 2 for the second
  # lowest etc. This makes people think that the differences
  # between each percentile group are the same, which is not
  # the case. Ordered factor makes more sense here.

  mutate(VCF0114 = as.character(as_factor(VCF0114)))  %>%

  separate(VCF0114, into = c(NA, "income"),
           sep = "[.]") %>%

  mutate(income = as.ordered(case_when(
    income == " 96 to 100 percentile" ~ "96 - 100",
    income == " 68 to 95 percentile" ~ "68 - 95",
    income == " 34 to 67 percentile" ~ "34 - 67",
    income == " 17 to 33 percentile" ~ "17 - 33",
    income == " 0 to 16 percentile" ~ "0 - 16"))) %>%


  # Cleaning year variable.

  mutate(year = as.integer(VCF0004)) %>%

  select(-VCF0004) %>%


  # Filtering out all 1948 observations because they are
  # lacking data on states and education.

  filter(year > 1948) %>%


  # Cleaning race variable.

  mutate(VCF0105a = as.character(as_factor(VCF0105a))) %>%


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

    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == F) ~ "Hispanic",

    # This terminology has been used after the 1964 election.

    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "Other",

    # This terminology has been used until and including the 1964 election,
    # after which they described to the respective group as "Other". In order
    # to avoid having two different terms for the same group of people in
    # different time periods, I decided to code this as "Other" as well.

    str_extract(VCF0105a, pattern = "Non-white") == "Non-white" ~ "Other",

    TRUE ~ NA_character_))) %>%


  # Dropping the leftover numeric race variable.

  select(-VCF0105a) %>%


  # Cleaning party / ideology variable. I chose a scale
  # that centers around 0 rather than one that goes from
  # 1 to 7, as this makes it easier to spot someone's
  # ideology by briefly looking at the data.

  mutate(VCF0301 = as_factor(VCF0301)) %>%

  separate(VCF0301, into = c(NA, "ideology"),
           sep = "[.]") %>%

  mutate(ideology = as.integer(case_when(
    ideology == " Strong Democrat" ~ -3,
    ideology == " Weak Democrat" ~ -2,
    ideology == " Independent - Democrat" ~ -1,
    ideology == " Independent - Independent" ~ 0,
    ideology == " Independent - Republican" ~ 1,
    ideology == " Weak Republican" ~ 2,
    ideology == " Strong Republican" ~ 3))) %>%


  # Cleaning education variable.

  mutate(VCF0140a = as.character(as_factor(VCF0140a))) %>%

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
    TRUE ~ NA_character_))) %>%


  # Converting education variable to ordered factor.

  mutate(education = factor(education,
                       levels = c("Elementary", "Some Highschool",
                                  "Highschool", "Highschool +",
                                  "Some College", "College", "Adv. Degree"),
                       ordered = T)) %>%


  # Dropping the leftover numeric education variable.

  select(-VCF0140a) %>%


  # Cleaning state variable. Going from a haven_labelled object to an
  # integer is fun. If you fail to pass through <chr> state before going
  # to integer, the integrity of the values is lost for a presently unknown
  # reason. I recalled this as a workaround from a previous project and
  # it worked, I tested for coherence throughout and this was the first
  # method I arrived at that results in accurate data.

  mutate(fips = as.integer(as.character(as_factor(VCF0901a)))) %>%


  # Dropping leftover state variable.

  select(-VCF0901a) %>%

  # Cleaning/renaming region variable

  mutate(region = as.factor(case_when(VCF0112 == 1 ~ "Northeast",
                                      VCF0112 == 2 ~ "Midwest",
                                      VCF0112 == 3 ~ "South",
                                      VCF0112 == 4 ~ "West"))) %>%

  # Dropping leftover region variable

  select(-VCF0112)


# Created a file with all fips codes and state abbreviations, based on info
# from https://www.nrcs.usda.gov/wps/portal/nrcs/detail/?cid=nrcs143_013696.
# Relevant .csv file included in `data-raw`.

fips_key <- read.csv("data-raw/fips_key.csv") %>%

  select(fips, state_abbr)


# Creating a new dataframe by joining NES and key dataframes by
# fips codes.

z <- x %>%
      left_join(fips_key, by = "fips") %>%

  mutate(state = state_abbr) %>%

  select(-fips, -state_abbr) %>%


# Cleaning voted variable.

  mutate(voted = as_factor(VCF0702)) %>%

  separate(col = voted, into = c("voted", "v2"),
           sep = "[.]") %>%

  mutate(voted = as.character(case_when(
             str_extract(v2, pattern = "voted") == "voted" ~ "Yes",
             str_extract(v2, pattern = "not") == "not" ~ "No",
             TRUE ~ NA_character_))) %>%

  select(-VCF0702, -v2) %>%


# Cleaning age group variable.

  mutate(age = as_factor(VCF0102)) %>%
  mutate(age = as.ordered(case_when(
    str_detect(age, "1. ") == T ~ "17 - 24",
    str_detect(age, "2. ") == T ~ "25 - 34",
    str_detect(age, "3. ") == T ~ "35 - 44",
    str_detect(age, "4. ") == T ~ "45 - 54",
    str_detect(age, "5. ") == T ~ "55 - 64",
    str_detect(age, "6. ") == T ~ "65 - 74",
    str_detect(age, "7. ") == T ~ "75 +",
    TRUE ~ NA_character_))) %>%




# Cleaning presidential approval variable. Need to find regex method
# to automatize the process of using case_when.

  mutate(pres_appr = as_factor(VCF0450)) %>%
  mutate(pres_appr = as.character(case_when(
    str_detect(pres_appr, "1. ") == T ~ "Approve",
    str_detect(pres_appr, "2. ") == T ~ "Disapprove",
    str_detect(pres_appr, "8. ") == T ~ "Unsure",
    TRUE ~ NA_character_))) %>%

  select(-VCF0102, -VCF0450) %>%

  select(year, state, gender, income, age,
         education, race, ideology, pres_appr, voted, region)


# Check and save.

stopifnot(nrow(z) > 32000)
stopifnot(length(levels(z$education)) == 7)
stopifnot(is.integer(z$year))
stopifnot(ncol(z) == 11)
stopifnot(dim(table(z$income)) == 5)


nes <- z

usethis::use_data(nes, overwrite = T)



