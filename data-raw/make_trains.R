# Script which cleans up the raw data from Enos (2016). This is mostly taken
# from Exam 2 in Fall 2019. I should consider adding a bunch more detail from my
# own train repo.

library(tidyverse)
library(usethis)

x <- read_csv("data-raw/pnas_data.csv",
                  col_types = cols(
                    .default = col_double(),
                    male = col_integer(),
                    liberal = col_integer(),
                    republican = col_integer(),
                    treated_unit = col_character(),
                    t.time = col_character(),
                    assignment = col_character(),
                    line.y = col_character(),
                    station = col_character(),
                    train = col_character(),
                    time = col_time(format = ""),
                    time.treatment = col_character()
                  )) %>%

  # We really only need a handful of these variables.

  select(numberim.x, Remain.x, Englishlan.x,
         numberim.y, Remain.y, Englishlan.y,
         treatment, liberal, republican, age,
         male, income.new) %>%

  # Create an overall measure of attitude change. Positive means becoming more
  # conservative. Should we normalize this number? Should we allow for an NA in
  # one or two of the three questions? We only lose 8 of the 123 observations
  # right now. But could rescue three of these if we allowed number_diff to be
  # NA. Only 5 are truly NAs, meaning the person did not answer any of the three
  # questions on the second survey.

  mutate(att_start = numberim.x + Remain.x + Englishlan.x,
         att_end = numberim.y + Remain.y + Englishlan.y) %>%

  # Delete component parts that we no longer need.

  select(- starts_with("numberim")) %>%
  select(- starts_with("Remain")) %>%
  select(- starts_with("Englishlan")) %>%

  # Handling NAs is always tricky. I should make it easy to see if saving the
  # three savable rows makes a substantive difference to any conclusion. But,
  # for this data set, I will only keep the 115 observations for which we have all
  # the data.

  drop_na(att_start, att_end) %>%

  rename(income = income.new) %>%

  # It is important to understand that sometimes we are happy to work with
  # treatment as a numeric variable with vales of zero and one. But, other
  # times, we want it to be a factor. And, once we decide we need a factor, we
  # might as well create a "proper" factor with named levels, and make an
  # affirmative choice for how we want the levels of that factor to be ordered.
  # In this case, I will keep both versions of treatment around: treatment and
  # treatment.2.

  mutate(treatment = ifelse(treatment == 1, "Treated", "Control")) %>%
  mutate(treatment = factor(treatment, levels = c("Treated", "Control"))) %>%

  # Not obvious what the best way to represent these variables are. Enos, for
  # example, works with 0/1 variables for male, liberal and republican. I don't
  # think that that is best for teaching.

  # Note that there are no liberal Republicans. So, what is your best guess for
  # their missing values? Great question! We should use the data we have for
  # liberals and for Republicans separately to make a guess.

  mutate(gender = ifelse(male, "Male", "Female")) %>%
  mutate(party = ifelse(republican, "Republican", "Democrat")) %>%
  mutate(liberal = ifelse(liberal, TRUE, FALSE)) %>%

  # I like setting age to integer, if only so we have a discussion point. Since,
  # we only have integer values of income and the attitudes, we might also set
  # them to integer. But I prefer to leave them as doubles since we will be
  # using them as left-hand side variables. Of course, the type of variable does
  # not affect the math of the calculation. I just think it is helpful to
  # "think" of them as continuous rather than discrete.

  # Might think about adding another variable or two sometime . . .

  select(gender, liberal, party, age, income, att_start,
         treatment, att_end)

# Code for saving object

trains <- x
usethis::use_data(trains, overwrite = TRUE)

