library(tidyverse)
library(janitor)

# This data set was originally used in the paper "Results from
# a 2020 field experiment encouraging voting by mail". The paper
# discussing the study and its results can be accessed at
# https://doi.org/10.1073/pnas.2021022118, the raw data used here
# is available at https://doi.org/10.7910/DVN/HUUEGI.

# Reading in the data. I included variables describing the treatment
# group ("treatment"), whether person either cast in-person or mail
# ballot ("voted"), whether person cast mail ballot ("voted_mail"),
# whether mail ballot application was received ("app_mail_ballot"),
# the number of days after March 10 that the mail ballot application
# was received ("app_received_mar"), days after May 18 that the mail
# ballot application was received ("app_received_may"), whether mail
# ballot was requested but not returned ("app_not_received"), party
# of registration ("party"), age group ("age"), sex ("sex"), likelihood
# of person being white according to their name ("pred_whi"), and
# likelihood of person being black ("pred_bla").
# Not included: days after March 10 that mail ballot was received (since
# the experiment was about the application or use of mail ballots in general
# and not the date), whether a mail ballot was received by the June 2 deadline
# (same as before), whether the person cast provisional ballots before, and
# ward of registration (neither seems interesting).

unzip("data-raw/mail.csv.zip")

x <- read_csv("mail.csv") %>%
  clean_names() %>%
  select("treatment" = treat_20,
         "voted" = voted_2020_primary,
         "voted_mail" = voted_mail_2020_primary,
         "app_mail_ballot" = requested_mail_ballot,
         "app_received_mar" = days_app_returned_fmt,
         "app_received_may" = diff_app_returned_date_fmt,
         "app_not_received" = requested_never_returned,
         party,
         "age" = age_bin,
         sex,
         pred_whi,
         pred_bla) %>%

  mutate(treatment = recode(treatment, Control = "No Postcard")) %>%


  # It may be suspicious if a dummy variable is of type double. The number
  # of days should also be an integer.

  mutate(voted = as.integer(voted),
         voted_mail = as.integer(voted_mail),
         app_mail_ballot = as.integer(app_mail_ballot),
         app_received_mar = as.integer(app_received_mar),
         app_received_may = as.integer(app_received_may),
         app_not_received = as.integer(app_not_received)) %>%


  # TW: I feel like there is an easier way to do this...

  mutate(age = factor(recode(age, "[18,30)" = "18-29",
                             "[30,40)" = "30-39",
                             "[40,50)" = "40-49",
                             "[50,65)" = "50-64",
                             "[65,121]" = "65-121"),
                      levels = c("18-29",
                                 "30-39",
                                 "40-49",
                                 "50-64",
                                 "65-121"))) %>%


  # More concise.

  mutate(party = recode(party, "No Affiliation" = "None")) %>%


  # TW: I am not sure what "U" in the "sex" variable refers to, and
  # the codebook does not mention anything either. Could be "Other"
  # or "Unknown", which can make a difference, but since this group
  # accounts for over 18% of observations, I strongly assume the latter.
  # So, recoding it as NA makes more sense here.

  mutate(sex = recode(sex, "M" = "Male",
                      "F" = "Female",
                      "U" = NA_character_)) %>%


  # Removing some strange observations. I wrote the first line by myself,
  # the other two deal with problems that are (kind of) mentioned in the
  # codebook. Apparently, this is a data collection issue.

  filter(!(voted_mail == 1 & voted == 0),                            # Voted by mail + didn't vote (10 obs)
         !(voted_mail == 1 & app_mail_ballot == 0),                  # Voted by mail + didn't apply for mail ballot (19 obs)
         !(is.na(app_received_may) == FALSE) & app_mail_ballot == 0) # Date application was received + didn't apply for mail ballot (12 obs)



# Save

mail <- x

usethis::use_data(mail, overwrite = TRUE)
