# work in progress preparing the data set from  Harris, Kamindo, and Windt (2020):
# Electoral Administration in Fledgling Democracies: Experimental Evidence from Kenya

# The replication data can be located at:
# https://dataverse.harvard.edu/dataset.xhtml;jsessionid=786d92e2aec3933f01bd0af48ec0?persistentId=doi%3A10.7910%2FDVN%2FUT25HQ&version=&q=&fileTypeGroupFacet=%22Code%22&fileAccess=&fileTag=&fileSortField=&fileSortOrder=

#  DISCARDED VARIABLES: weight (needed?), INTERVENTION (same as the first one?), DATE_DAY1 (include this or date or both?)
# TO-DO: Go from individuals --> communities, documentation not showing up

library(tidyverse)
library(usethis)

# diff read function
x <- readRDS('data-raw/kenyadata.Rds')

x <- x %>%

  # Recoding values for treatment variable

  mutate(treatment = as.factor(case_when(treat == "Control" ~ "control",
                                         treat == "SMS" ~ "SMS",
                                         treat == "Canvass" ~ "canvass",
                                         treat == "Local" ~ "local",
                                         treat == "Local+Canvass" ~ "local + canvass",
                                         treat == "Local+SMS" ~ "local + SMS"))) %>%

  # Renaming variables for poverty, population density, date, block id, polling station id

  mutate(block = as.character(BLOCK_ID),
         poll_station = PS_ID,
         poverty = pov,
         pop_density = pd,
         mean_age = mean.age,
         reg_byrv13 = reg_int_byrv13) %>%

  # Selecting final variabless

  select(block, poll_station, treatment, poverty, distance, pop_density, mean_age, reg_byrv13, rv13) %>%

  as_tibble()


stopifnot(nrow(x) > 1600)
stopifnot(ncol(x) == 9)
stopifnot(is.factor(x$treatment))
stopifnot(is.character(x$block))


kenya <- x
usethis::use_data(kenya, overwrite = TRUE)


# Todo: Check if reg/rv13 descriptions and date descriptions ar right.

