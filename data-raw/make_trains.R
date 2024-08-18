# Script which cleans up the raw data from Enos (2016). This is mostly taken
# from Exam 2 in Fall 2019. I should consider adding a bunch more detail from my
# own trains repo, the code for which is much more detailed. I can't find a code
# book so there may be mistakes here. Key is that variables with ".y" come from
# second survey.

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
                  )) |>

  # Percent Hispanic in the district is not the most important variable, but we
  # need more continuous covariates to play with. I am suspicious about the raw
  # numbers because they seemed to include an absurd number of significant
  # digits. So, I rounded.

  mutate(hisp_perc = round(zip.pct.hispanic, 4)) |>

  # Looks like the raw race data is race_1 (14), race_2 (4), race_3 (2), race_4
  # (102) and race_5 (10). I am not sure if what I have done here is correct!
  # Note that variables like Hispanics.x are confusing! My reasoning: White is
  # the default. hispanic.new is a created variable, so it can be trusted.
  # race_1 is Asian. race_2 is Black. (Note that the numbers involved make sense
  # for Boston commuters from the suburbs --- many more Asian than Black.)

  mutate(race = "White") |>
  mutate(race = ifelse(hispanic.new == 1, "Hispanic", race)) |>
  mutate(race = ifelse(race_1 %in% c(1), "Asian", race)) |>
  mutate(race = ifelse(race_2 %in% c(1), "Black", race)) |>

  # Ideology looks like an interesting variable, not least because it has 5
  # values with a fair spread among them. Could recode this by the character
  # values (if I knew them), but I think it is nice to have a numeric. I wonder
  # if the experiment changes people's ideologies as well? Forking paths! Also,
  # good example to add ideology_end into the regresssion and explain why that
  # is bad.

  mutate(ideology_start = as.integer(ideology.x)) |>
  mutate(ideology_end = as.integer(ideology.y)) |>

  # Want to look at the two train lines separately, as well as the train
  # stations.

  separate(col = treated_unit,
           into = c("line", "station", "platform"),
           sep = "_") |>

  # Create an overall measure of attitude change. Positive means becoming more
  # conservative. Should we normalize this number? Should we allow for an NA in
  # one or two of the three questions? We only lose 8 of the 123 observations
  # right now. But could rescue three of these if we allowed number_diff to be
  # NA. Only 5 are truly NAs, meaning the person did not answer any of the three
  # questions on the second survey.

  mutate(att_start = numberim.x + Remain.x + Englishlan.x,
         att_end = numberim.y + Remain.y + Englishlan.y) |>

  # Delete component parts that we no longer need.

  select(- starts_with("numberim")) |>
  select(- starts_with("Remain")) |>
  select(- starts_with("Englishlan")) |>

  # Handling NAs is always tricky. I should make it easy to see if saving the
  # three savable rows makes a substantive difference to any conclusion. But,
  # for this data set, I will only keep the 115 observations for which we have all
  # the data.

  drop_na(att_start, att_end) |>

  # income.new is the variable used in the paper. Not sure why it is better than
  # the (origina) income variable.

  mutate(income = income.new) |>

  # It is important to understand that sometimes we are happy to work with
  # treatment as a numeric variable with vales of zero and one. But, other
  # times, we want it to be a factor. And, once we decide we need a factor, we
  # might as well create a "proper" factor with named levels, and make an
  # affirmative choice for how we want the levels of that factor to be ordered.

  mutate(treatment = ifelse(treatment == 1, "Treated", "Control")) |>
  mutate(treatment = factor(treatment, levels = c("Control", "Treated"))) |>

  # Not obvious what the best way to represent these variables are. Enos, for
  # example, works with 0/1 variables for male, liberal and republican. I don't
  # think that that is best for teaching.

  # Note that there are no liberal Republicans. So, what is your best guess for
  # their missing values? Great question! We should use the data we have for
  # liberals and for Republicans separately to make a guess.

  mutate(age = as.integer(age)) |>
  mutate(sex = ifelse(male, "Male", "Female")) |>
  mutate(party = ifelse(republican, "Republican", "Democrat")) |>
  mutate(liberal = ifelse(liberal, TRUE, FALSE)) |>

  # I like setting age to integer, if only so we have a discussion point. Since,
  # we only have integer values of income and the attitudes, we might also set
  # them to integer. But I prefer to leave them as doubles since we will be
  # using them as left-hand side variables. Of course, the type of variable does
  # not affect the math of the calculation. I just think it is helpful to
  # "think" of them as continuous rather than discrete.

  # Might think about adding another variable or two sometime . . .

  select(treatment, att_start, att_end,
         sex, race, liberal, party, age, income,
         line, station, hisp_perc,
         ideology_start, ideology_end)

# Code for saving object

trains <- x
usethis::use_data(trains, overwrite = TRUE)

