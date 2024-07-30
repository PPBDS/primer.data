# Script for cleaning cces data (Shiro 18). My intention here is to create two
# basic paths available for analysis. First, there's the basic analysis of
# whether different demographics have significantly different answers. Second,
# there's the analysis of approval of different levels of government official
# (pres, senator, governor). Shiro updates the data whenever CCES is updated.
# Latest is for 2022.

# So, initially, I've kept most of the demographic information. Currently
# working on deciding which survey questions to keep. I discuss my choices below
# the select function.

library(tidyverse)
library(haven)
library(usethis)

raw <- read_rds("data-raw/cumulative_2006-2022.rds") |>
      select(case_id, year, state,

             # Always a tricky issue.

             sex = gender,

             # I kept age instead of birth year because it records the age when
             # they took the survey, which is most relevant. Not sure if I
             # should keep all these variables.

             age, race, marstat, religion, faminc,

             # I've renamed ideo5 to ideology because I've removed every other
             # ideology based question.

             ideology = ideo5,

             # I've kept three sort of groups of variables. The first is
             # ideology and news interest - I'm curious to see if there's a
             # relationship between self-reported news interest and
             # self-reported political ideology.

             # The second is a retrospective view of the economy (how has the
             # economy been doing this past year?) with the approval of the
             # current president. That's probably correlated?

             education = educ,
             news = newsint,
             econ = economy_retro,
             approval_ch = approval_pres,
             military = no_milstat,
             voted = vv_turnout_gvm)

x <- raw |>

  # Handy to keep presidential approval as both a number and a factor. Or is it?

  mutate(approval = as.integer(approval_ch)) |>

  # Tricky thing is that values 5 and 6 are, sort of NA. One might consider them
  # as neutral as well. But, for now, we just NA them.

  mutate(approval = if_else(approval %in% c(5, 6), NA, approval)) |>

  # Previous versions did a lot of transformations of variables by hand, mapping
  # numeric codes to character variables. Now, however, we just do it
  # automagically with special haven functions.

  mutate(across(where(haven::is.labelled), haven::as_factor)) |>

  # There is a trickiness in approval_ch. First, not sure if this is the best
  # name for this variable. Second we combine "Never Heard / Not Sure" and
  # "Neither Approve Nor Disapprove" since the latter seemed to be used in only
  # one year in the survey. But note that both were turned into NA for approval.

  mutate(approval_ch = fct_collapse(approval_ch,
                                    "Neither Approve nor Disapprove" =
                                      c("Neither Approve nor Disapprove",
                                        "Never Heard / Not Sure"))) |>
  mutate(approval_ch = fct_relevel(
    approval_ch, "Strongly Approve",
                 "Approve / Somewhat Approve",
                 "Neither Approve nor Disapprove",
                 "Disapprove / Somewhat Disapprove",
                 "Strongly Disapprove")) |>
  mutate(approval_ch = ordered(approval_ch))

# This replaces all "Prefer not to say", "Note asked" and "Skipped" answers
# with NA. I don't think it makes a difference for us why we got no answer.

levels(x$faminc)[levels(x$faminc) == c("Prefer not to say", "Skipped")] <- NA


# I used to grab special race related variables (CC442a and CC359) from some
# other data sets in 2010 and 2011. I I also was interested in opinions about
# affirmative action (CC327 and CC354). Let's ignore all that for now.

# Save the data.

cces <- x

usethis::use_data(cces, overwrite = TRUE)


