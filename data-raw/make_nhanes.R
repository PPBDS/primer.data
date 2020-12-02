
library(NHANES)
library(tidyverse)

# This dataset is from on the National Health and Nutrition Examination Survey
# (NHANES), a program designed to assess the health status of adults and children
# in the United States. It is conducted yearly by a suborganization of the CDC,
# and involves both interviews and physical examinations of participants. The raw
# data can be accessed through their R package, details about the study can be
# found at https://www.cdc.gov/nchs/nhanes/index.htm.

# Loading the data and selecting the variables to be used. The dataset includes
# more than 70 variables, so there are many more potentially useful variables
# than we could possibly include. The ones below are some of the more well known
# measures that are relatively easy to interpret.

x <- NHANES %>%

        select(SurveyYr, Gender, Age,
               Race1, Education, HHIncome,
               Weight, Height, BMI, Pulse,
               Diabetes, HealthGen, Depressed,
               nPregnancies, SleepHrsNight) %>%


  # Recoding 'SurveyYr' by converting it to a new variable name 'survey'.
  # This variable only includes the first year, the second year is dropped. For
  # example, "2011_12" will just be represented as "2011". This may not be
  # totally correct, but it eases further analyses while creating only minor
  # distortions (it's unlikely that people's health status changes a lot within
  # half a year).

  separate(SurveyYr, into = c("survey", NA),
           sep = "_") %>%


  # Converting the new 'survey' variable to an integer.

  mutate(survey = as.integer(survey)) %>%


  # Recoding some levels of 'Education' and converting it to
  # an ordered factor.

  mutate(Education = as.ordered(case_when(
    Education == "8th Grade" ~ "Middle School",
    Education == "9 - 11th Grade" ~ "Middle School",
    Education == "High School" ~ "High School",
    Education == "Some College" ~ "Some College",
    Education == "College Grade" ~ "College"))) %>%


  # Recoding some values of 'HHIncome' and converting it to an
  # ordered factor. Having ranges instead of single values looks
  # ugly, but this is still the best solution.
  # There are two other options to deal with this variable, but
  # both of them come with a problem. The first option to the
  # below approach would be to recode the ranges as numbers, with
  # the first group being "1" and the second group being "2", etc.
  # However, this could imply a linear relationship between numbers
  # and and ranges of each group, which would be wrong (e.g. the
  # first group covers a range of 5k, the last group a range of 25k).
  # The second option would be to use 'HHIncomeMid' variable in the
  # dataset, which uses the median/mean of each group's range instead
  # of the range itself. However, unless peoples' incomes in each
  # group follow a normal or equal distribution that is centered
  # around the mean/median of the respective range, this would lead
  # to distortions. For example, it makes little sense to assume that
  # the average income of all people in the group "75000-99999" is
  # equal to this ranges' median of 87500. Instead, we would expect
  # much fewer observations at the upper range, leading to a value that
  # may not even be close to 87500.

  mutate(HHIncome = as.ordered(case_when(
    HHIncome == "more 99999" ~ "over 99999",
    HHIncome == "75000-99999" ~ "75000-99999",
    HHIncome == "65000-74999" ~ "65000-74999",
    HHIncome == "55000-64999" ~ "55000-64999",
    HHIncome == "45000-54999" ~ "45000-54999",
    HHIncome == "35000-44999" ~ "35000-44999",
    HHIncome == "25000-34999" ~ "25000-34999",
    HHIncome == "20000-24999" ~ "20000-24999",
    HHIncome == "15000-19999" ~ "15000-19999",
    HHIncome == "10000-14999" ~ "10000-14999",
    HHIncome == " 5000-9999" ~ "5000-9999",
    HHIncome == " 0-4999" ~ "0-4999"))) %>%


  # Converting 'HealthGen' to a numbered variable. Although it
  # may again be problematic to assume a linear relationship
  # between each of the five responses, this approach seems
  # appropriate here. Keep in mind that these exact responses
  # were offered by the researchers after asking people for their
  # general health conditions. This is pretty close to a question
  # of the form "On a scale of 1 to 5, and 5 being best, how well
  # do you feel?".

  mutate(HealthGen = as.integer(case_when(
    HealthGen == "Poor" ~ 1,
    HealthGen == "Fair" ~ 2,
    HealthGen == "Good" ~ 3,
    HealthGen == "Vgood" ~ 4,
    HealthGen == "Excellent" ~ 5))) %>%


  # Converting 'Depressed' to an ordered factor.

  mutate(Depressed = as.ordered(Depressed)) %>%


  # Converting 'Diabetes' to an integer variable.

  mutate(Diabetes = as.integer(case_when(
    Diabetes == "Yes" ~ 1,
    Diabetes == "No" ~ 0))) %>%


  # No factors unless it's necessary.

  mutate(Gender = as.character(Gender),
         Race1 = as.character(Race1)) %>%


  # Capitalizing values of 'Gender'.

  mutate(Gender = str_to_title(Gender)) %>%


  # Renaming variables.

  rename(gender = "Gender",
         age = "Age",
         race = "Race1",
         education = "Education",
         hh_income = "HHIncome",
         weight = "Weight",
         height = "Height",
         bmi = "BMI",
         pulse = "Pulse",
         diabetes = "Diabetes",
         general_health = "HealthGen",
         depressed = "Depressed",
         pregnancies = "nPregnancies",
         sleep = "SleepHrsNight")


# Check and save.

stopifnot(nrow(x) == 10000)
stopifnot(ncol(x) > 10)
stopifnot(ncol(x) < 16)
stopifnot(is.integer(x$age))
stopifnot(is.character(x$race))
stopifnot(sum(is.na(x$depressed)) < 5000)

nhanes <- x
usethis::use_data(nhanes, overwrite = TRUE)




