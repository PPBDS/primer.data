library(tidyverse)
library(haven)
library(janitor)

# This dataset is from the paper "Public policy for the poor? A randomised
# assessment of the Mexican universal health insurance programme (2009)."
# The treatment consisted of encouragement to enroll in a health-insurance
# programme and upgraded medical facilities. Participant states also received
# funds to improve health facilities and to provide medications for services in
# treated clusters.



# P03D11 Health care costs, excluding travel expenses related to seeking health
# care and any reimbursement of health insurance? (of the past month)


x <- read_dta("data-raw/sps.dta") %>%
  clean_names() %>%

  # This data file covers 647 variables from a pre- and pos-treament survey.
  # Althought the dataverse readme says there is a Spanish and English codebook,
  # only the Spanish version is available on the site.

  mutate(health_exp_3m = p03d15 + p03d16 + p03d17 + p03d18 + p03d19 + p03d20 + p03d21 + p03d22,

         # this adds together different types of medical expenses into a single
         # 3-months health expenditures variable.

         t2_health_exp_3m = p03d15_t2 + p03d16_t2 + p03d17_t2 + p03d18_t2 + p03d19_t2 + p03d20_t2 +
           p03d21_t2 + p03d22_t2) %>%

  # For questions 12.13 & 12.14, it appears that the answers were originally
  # coded: 1 = agree, 2 = disagree, 9 = don't know. The new variable has been
  # recorded to 0, 1, and NA.

  # p12d13 Do you agree that: The government should try to reduce differences
  # between rich and poor?

  # p12d14 Do you agree that: We should privatize the electricity industry to
  # make it more efficient?

  rename(ideology = p12d20,
         t2_ideology = p12d20_t2,

         # To which of the following political positions do you identify
         # yourself the most?

         ec_better = p12d21,
         t2_ec_better = p12d21_t2,

         # Compared to five years ago, do you think Mexico is better or worse
         # today economically?

         pol_better = p12d22,
         t2_pol_better = p12d22_t2,

         # Compared to five years ago, do you think Mexico is better or worse
         # today politically?

         health_exp_1m = p03d11,
         t2_health_exp_1m = p03d11_t2) %>%


  # Note that for the "_better" questions the responses seem to have been recorded
  # 1 = Better = 1, 2 = Worse = -1, 3 = Same = 0, 8 = Don’t answer = NA, 9 = Don’t
  # know = NA. This is my interpretation, but I am still trying to figure out if
  # this is the actual recoding the authors used.

  mutate(sex = if_else(sex == 0, "male", "female"),

         treatment = as.factor(treatment),

         age = as.integer(age),

         education = case_when(educ == 0 ~ "none",
                               educ == 1 ~ "preschool",
                               educ == 2 ~ "primary",
                               educ == 3 ~ "secondary",
                               educ == 4 ~ "high school",
                               educ %in% c(5,7) ~ "college",
                               educ == 6 ~ "techinical",
                               educ == 8 ~ "post-grad"),

         # Secondary equates to middle school. Normal is the equivalent of a
         # bachelor's degree, but only for teaching. Normal, Technical or
         # college are all potential paths post high school graduation. I
         # decided to put normal and college together because they are both
         # bachelor's degrees.

         ideology = case_when(ideology == 1 ~ "left",
                              ideology == 2 ~ "center-left",
                              ideology == 3 ~ "center",
                              ideology == 4 ~ "center-right",
                              ideology == 5 ~ "right"),
         t2_ideology = case_when(t2_ideology == 1 ~ "left",
                                 t2_ideology == 2 ~ "center-left",
                                 t2_ideology == 3 ~ "center",
                                 t2_ideology == 4 ~ "center-right",
                                 t2_ideology == 5 ~ "right"),
         ec_better = case_when(ec_better == -1 ~ "worse",
                               ec_better == 0 ~ "same",
                               ec_better == 1 ~ "better"),
         pol_better = case_when(pol_better == -1 ~ "worse",
                                pol_better == 0 ~ "same",
                                pol_better == 1 ~ "better")) %>%


  # These variables (ideology, t2_ideology, ec_better, t2_ec_better, pol_better,
  # t2_pol_better) are not in the paper's abstract, but may provide interesting
  # insights into how SPS affected people politics and their political opinions.

  # I'm debating whether to use a numeric or factor variable for ideology and
  # "_better" variables.


  select(age, sex, education, treatment, health_exp_3m, t2_health_exp_3m, health_exp_1m, t2_health_exp_1m) %>%

# From the readme on dataverse: A codebook for the survey questionnaire appears
# in both Spanish and English. However, the English version cannot be found. I
# managed to translate the Spanish codebook to English and saved it as a .xlsx file
# name "sps_codebook". See /data-raw for a copy of it. Make sure to open it in Excel,
# since it contains merged cells which are messed up by R.




  drop_na()

stopifnot(nrow(x) > 20000)
stopifnot(is.character(x$sex))
stopifnot(ncol(x) == 8)



sps <- x
usethis::use_data(sps, overwrite = TRUE)
