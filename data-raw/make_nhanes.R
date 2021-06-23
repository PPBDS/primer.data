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

# Make use of this next time?

# https://cran.r-project.org/web/packages/nhanesA/vignettes/Introducing_nhanesA.html

x <- NHANES %>%

        select(SurveyYr, Gender, Age,
               Race1, Education, HHIncome,
               Weight, Height, BMI, Pulse,
               Diabetes, HealthGen, Depressed,
               nPregnancies, SleepHrsNight) %>%


  # Recoding 'SurveyYr' by converting it to a new variable name 'survey'. This
  # variable only includes the first year, the second year is dropped. For
  # example, "2011_12" will just be represented as "2011". This may not be
  # totally correct, but it eases further analyses while creating only minor
  # distortions (it's unlikely that people's health status changes a lot within
  # half a year).

  separate(SurveyYr, into = c("survey", NA),
           sep = "_") %>%


  # Converting the new 'survey' variable to an integer.

  mutate(survey = as.integer(survey)) %>%


  # Recoding some levels of 'Education' and converting it to a factor. Why are
  # 25% of the observations NA?

  mutate(Education = as.factor(case_when(
    Education == "8th Grade" ~ "Middle School",
    Education == "9 - 11th Grade" ~ "Middle School",
    Education == "High School" ~ "High School",
    Education == "Some College" ~ "Some College",
    Education == "College Grad" ~ "College"))) %>%

  mutate(Education = fct_relevel(Education,
                                 "Middle School",
                                 after = 0)) %>%


  # Note that we could use 'HHIncomeMid' variable in the dataset, which uses the
  # median/mean of each group's range instead of the range itself. However,
  # unless peoples' incomes in each group follow a normal or equal distribution
  # that is centered around the mean/median of the respective range, this would
  # lead to distortions. For example, it makes little sense to assume that the
  # average income of all people in the group "75000-99999" is equal to this
  # ranges' median of 87500. Instead, we would expect much fewer observations at
  # the upper range, leading to a value that may not even be close to 87500. So,
  # the only change we make is to get rid of the annoying spaces in levels like
  # " 0-4999".

  mutate(HHIncome = fct_relabel(HHIncome, ~ gsub("^ ", "", .x))) %>%

  # Converting 'HealthGen' to a numbered variable. Although it may again be
  # problematic to assume a linear relationship between each of the five
  # responses, this approach seems appropriate here. Keep in mind that these
  # exact responses were offered by the researchers after asking people for
  # their general health conditions. This is pretty close to a question of the
  # form "On a scale of 1 to 5, and 5 being best, how well do you feel?".

  mutate(HealthGen = as.integer(case_when(
    HealthGen == "Poor" ~ 1,
    HealthGen == "Fair" ~ 2,
    HealthGen == "Good" ~ 3,
    HealthGen == "Vgood" ~ 4,
    HealthGen == "Excellent" ~ 5))) %>%


  # Converting 'Depressed' to a factor.

  mutate(Depressed = as.factor(Depressed)) %>%


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




