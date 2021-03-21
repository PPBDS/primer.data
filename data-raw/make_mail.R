library(tidyverse)
library(janitor)

# This data set was originally used in the paper "Results from
# a 2020 field experiment encouraging voting by mail". The paper
# discussing the study and its results can be accessed at
# https://doi.org/10.1073/pnas.2021022118, the raw data used here
# is available at https://doi.org/10.7910/DVN/HUUEGI.

# Reading in the data. I included variables describing the treatment
# group ("treatment"), the number of days after March 10 that the
# mail ballot application was received ("app_returned_march"),
# days after May 18 that the mail ballot application was received ("app_returned_may"),
# whether mail ballot application was received ("requested_mail_ballot"),
# whether mail ballot was requested but not returned ("requested_never_returned"),
# whether person either cast in-person or mail ballot ("voted"),
# whether person cast mail ballot ("voted_mail"),
# party of registration ("party"), age group ("age"), sex ("sex"),
# likelihood of person being white according to their name ("pred_whi"),
# and likelihood of person being black ("pred_bla").

unzip("data-raw/mail.csv.zip")

x <- read_csv("data-raw/mail.csv") %>%
        clean_names() %>%
        select("treatment" = treat_20,
               "app_returned_march" = days_app_returned_fmt,
               "app_returned_may" = diff_app_returned_date_fmt,
               requested_mail_ballot,
               requested_never_returned,
               "voted" = voted_2020_primary,
               "voted_mail" = voted_mail_2020_primary,
               party,
               "age" = age_bin,
               sex,
               pred_whi,
               pred_bla) %>%



