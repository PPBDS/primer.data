library(tidyverse)
library(janitor)

# This data set was originally used in the paper "Results from a 2020 field
# experiment encouraging voting by mail". The paper discussing the study and its
# results can be accessed at https://doi.org/10.1073/pnas.2021022118, the raw
# data used here is available at https://doi.org/10.7910/DVN/HUUEGI.


# Reading in the data. I included variables describing the treatment group
# ("treatment"), whether person either cast in-person or mail ballot ("voted"),
# whether person cast mail ballot ("voted_mail"), whether mail ballot
# application was received ("applied_mail"), the number of days after March 10
# that the mail ballot application was received ("applied_days_arch"), the
# number of days after March 10 that the mail ballot itself was received
# ("voted_days_march"), party of registration ("party"), age group ("age"),
# sex ("sex"), likelihood of person being white according to their name
# ("pred_white"), and likelihood of person being black ("pred_black").

# NOT INCLUDED: days after May 18 (i.e. when postcards were sent) that mail
# ballot application was received (since days after March is enough), days after
# March 10 that mail ballot was received (since the experiment was about the
# application or use of mail ballots in general and not the date), whether a
# mail ballot was received by the June 2 deadline (same as before), whether the
# person cast provisional ballots before and ward of registration (neither seems
# interesting), and whether someone applied for a mail ballot but did not return
# it (as this can easily be inferred from "voted_mail" and "applied_mail").

unzip("data-raw/mail.csv.zip")

x <- read_csv("mail.csv") %>%
  clean_names() %>%
  select("treatment" = treat_20,
         "voted" = voted_2020_primary,
         "voted_mail" = voted_mail_2020_primary,
         "applied_mail" = requested_mail_ballot,
         "applied_days_march" = days_app_returned_fmt,
         "voted_days_march" = days_ballot_returned_fmt,
         party,
         "age" = age_bin,
         sex,
         "pred_white" = pred_whi,
         "pred_black" = pred_bla) %>%

  mutate(treatment = recode(treatment, Control = "No Postcard")) %>%


  # It always makes me suspicious when a binary variable that supposedly
  # consists of only 0s and 1s is coded a double. An integer makes more sense
  # here.

  mutate(voted = as.integer(voted)) %>%


  # Dummy variables should be "Yes" and "No" unless they are used as outcome
  # variables. In our case, the outcome variable will most likely be whether
  # someone voted at all, and the day when the mail application was received
  # (created further below).

  mutate(voted_mail = recode(as.character(voted_mail), "0" = "No",
                                                       "1" = "Yes"),

         applied_mail = recode(as.character(applied_mail), "0" = "No",
                                                           "1" = "Yes")) %>%


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


  # TW: I am not sure what "U" in the "sex" variable refers to, and the codebook
  # does not mention anything either. Could be "Other" or "Unknown", which can
  # make a difference, but since this group accounts for over 18% of observations,
  # I strongly assume the latter. So, recoding it as NA makes more sense here.

  mutate(sex = recode(sex, "M" = "Male",
                      "F" = "Female",
                      "U" = NA_character_)) %>%


  # Removing some strange observations. These conditions deal with problems that
  # are (kind of) mentioned in the codebook. Apparently, this is due to a data
  # collection issue. The first condition removes people who are recorded to
  # have voted by mail, but did not apply for a mail ballot (19 observations).
  # The second condition removes people who had a date at which their mail
  # ballot application was received, but who also did not apply for a mail
  # ballot (38 observations).

  filter(!(voted_mail == "Yes" & applied_mail == "No"),
         !(is.na(applied_days_march) == FALSE & applied_mail == "No"))


  # Creating a variable showing the date when mail application was received.
  # This is easier to understand than the number of days since March 10.

  x$applied_date <- as.Date("2020-03-10")

x <-  x %>%
    mutate(applied_date = applied_date + applied_days_march) %>%
    select(-applied_days_march)


  # Doing the same for the date when the mail ballot itself was received.

  x$voted_date <- as.Date("2020-03-10")

x <-  x %>%
  mutate(voted_date = voted_date + voted_days_march) %>%
  select(-voted_days_march) %>%
  select(treatment, voted, voted_mail,
         applied_mail, applied_date,
         voted_date, everything())


# Save

mail <- x

usethis::use_data(mail, overwrite = TRUE)
