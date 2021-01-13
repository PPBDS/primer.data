# Script for cleaning cces data (Shiro 18). My intention here is to create two
# basic paths available for analysis. First, there's the basic analysis of whether
# different demographics have significantly different answers. Second, there's the
# analysis of approval of different levels of government official (pres, senator,
# governor).

# So, initially, I've kept most of the demographic information. Currently working
# on deciding which survey questions to keep. I discuss my choices below the
# select function.

library(tidyverse)
library(usethis)

x <- read_rds("data-raw/cumulative_2006_2019.rds") %>%
      select(case_id, year, state, gender,

    # I kept age instead of birth year because it records the age when they took
    # the survey, which is most relevant. Not sure if I should keep all these
    # variables. Are we using this data for the heavy machine learning stuff in
    # chapters 11 and 12? If not this data, then what data?

    age, race, marstat, religion, faminc,


    # I've renamed ideo5 to ideology because I've removed every other
    # ideology based question.

    ideology = ideo5,
    education = educ,
    news = newsint,
    econ = economy_retro,
    approval_ch = approval_pres,
    military = no_milstat,
    voted = vv_turnout_gvm) %>%

  # I've kept three sort of groups of variables. The first is ideology and
  # news interest - I'm curious to see if there's a relationship between
  # self-reported news interest and self-reported political ideology.

  # The second is a retrospective view of the economy (how has the economy
  # been doing this past year?) with the approval of the current president. That's probably
  # correlated?

  # Below, I convert some of the numerical representations of the data into
  # consistent character variables.

  # There is a trickiness is the value 3 for approval. You need to include both
  # "Never Heard / Not Sure" and "Neither Approve Nor Disapprove" since the
  # latter seemed to be used in only one year in the survey.

  mutate(approval = case_when(
    approval_ch == 1 ~ 5,
    approval_ch == 2 ~ 4,
    approval_ch == 3 ~ 2,
    approval_ch == 4 ~ 1,
    approval_ch == 5 ~ 3,
    approval_ch == 6 ~ 3)) %>%

  mutate(approval_ch = case_when(
    approval_ch == 1 ~ "Strongly Approve",
    approval_ch == 2 ~ "Approve / Somewhat Approve",
    approval_ch == 3 ~ "Disapprove / Somewhat Disapprove",
    approval_ch == 4 ~ "Strongly Disapprove",
    approval_ch == 5 ~ "Never Heard / Not Sure",
    approval_ch == 6 ~ "Neither Approve Nor Disapprove")) %>%

  mutate(econ = case_when(
    econ == 1 ~ "Gotten Much Better",
    econ == 2 ~ "Gotten Better / Somewhat Better",
    econ == 3 ~ "Stayed About The Same",
    econ == 4 ~ "Gotten Worse / Somewhat Worse",
    econ == 5 ~ "Gotten Much Worse",
    econ == 6 ~ "Not Sure")) %>%

  mutate(news = case_when(
    news == 1 ~ "Most Of The Time",
    news == 2 ~ "Some Of The Time",
    news == 3 ~ "Only Now And Then",
    news == 4 ~ "Hardly At All",
    news == 7 ~ "Don't Know")) %>%

  mutate(gender = case_when(
    gender == 1 ~ "Male",
    gender == 2 ~ "Female")) %>%

  mutate(education = case_when(
    education == 1 ~ "No HS",
    education == 2 ~ "High School Graduate",
    education == 3 ~ "Some College",
    education == 4 ~ "2-Year",
    education == 5 ~ "4-Year",
    education == 6 ~ "Post-Grad")) %>%

  mutate(race = case_when(
    race == 1 ~ "White",
    race == 2 ~ "Black",
    race == 3 ~ "Hispanic",
    race == 4 ~ "Asian",
    race == 5 ~ "Native American",
    race == 6 ~ "Mixed",
    race == 7 ~ "Other",
    race == 8 ~ "Middle Eastern")) %>%

  mutate(marstat = case_when(
    marstat == 1 ~ "Married",
    marstat == 2 ~ "Separated",
    marstat == 3 ~ "Divorced",
    marstat == 4 ~ "Widowed",
    marstat == 5 ~ "Single / Never Married",
    marstat == 6 ~ "Domestic Partnership")) %>%

  mutate(religion = case_when(
    religion == 1 ~ "Protestant",
    religion == 2 ~ "Catholic",
    religion == 3 ~ "Mormon",
    religion == 4 ~ "Eastern or Greek Orthodox",
    religion == 5 ~ "Jewish",
    religion == 6 ~ "Muslim",
    religion == 7 ~ "Buddhist",
    religion == 8 ~ "Hindu",
    religion == 9 ~ "Atheist",
    religion == 10 ~ "Agnostic",
    religion == 11 ~ "Nothing in Particular",
    religion == 12 ~ "Other")) %>%

  mutate(military = case_when(
    military == "Yes" ~ "No",
    military == "No" ~ "Yes")) %>%


  # Creating some factors.

  mutate(education = factor(education,
                            levels = c("No HS",
                                       "High School Graduate",
                                       "Some College",
                                       "2-Year",
                                       "4-Year",
                                       "Post-Grad"))) %>%

  mutate(faminc = factor(faminc,
                            levels = c("Less than 10k",
                                       "10k - 20k",
                                       "20k - 30k",
                                       "30k - 40k",
                                       "40k - 50k",
                                       "50k - 60k",
                                       "60k - 70k",
                                       "70k - 80k",
                                       "80k - 100k",
                                       "100k - 120k",
                                       "120k - 150k",
                                       "150k+",
                                       "Prefer not to say",
                                       "Skipped"))) %>%



  # Getting rid of those pesky +lbl variables.

    mutate(gender = as.character(as_factor(gender)),
           race = as.character(as_factor(race)),
           marstat = as.character(as_factor(marstat)),
           religion = as.character(as_factor(religion)),
           education = as_factor(education),
           econ = as_factor(econ),
           approval_ch = as_factor(approval_ch),
           voted = as.character(voted))


  # Special question on race that was only asked in 2010 and 2011. I
  # had to separately download the two data sets to get this variable.

a <- read_rds("data-raw/cces_2010.rds") %>%
      select(V100, CC422a) %>%
      rename(case_id = V100,
             resentment = CC422a) %>%
      mutate(resentment = as_factor(resentment))

b <- read_rds("data-raw/cces_2011.rds") %>%
      select(V100, CC359) %>%
      rename(case_id = V100,
             resentment = CC359)

c <- rbind(a,b)

x <- x %>%
      left_join(c, by = "case_id")


  # Another special question on affirmative action that was only asked
  # in 2009, 2010 and 2011. Same procedure as before.

a <- read_rds("data-raw/cces_2010.rds") %>%
      select(V100, CC327) %>%
      rename(case_id = V100,
             aff_action = CC327) %>%
      mutate(aff_action = as_factor(aff_action))

b <- read_rds("data-raw/cces_2011.rds") %>%
      select(V100, CC354) %>%
      rename(case_id = V100,
             aff_action = CC354)

c <- rbind(a,b)

x <- x %>%
      left_join(c, by = "case_id") %>%
      select(-case_id) %>%
      select(year:approval_ch, approval, military, voted, resentment, aff_action)


# This replaces all "Prefer not to say", "Note asked" and "Skipped" answers
# with NA. I don't think it makes a difference for us why we got no answer.

levels(x$faminc)[levels(x$faminc) == c("Prefer not to say", "Skipped")] <- NA
levels(x$resentment)[levels(x$resentment) == c("Not Asked", "Skipped")] <- NA
levels(x$aff_action)[levels(x$aff_action) == c("Not Asked", "Skipped")] <- NA

# Save the data.

cces <- x

usethis::use_data(cces, overwrite = TRUE)


