# Script for cleaning connectedness data. The original data, from
# the Opportunity Insights project, was downloaded from

# https://data.humdata.org/dataset/social-capital-atlas

# on 2023-03-04. The data is called "Social Capital Atlas - US Counties.csv" and
# was listed as "Updated: 1 August 2022."

# Baseline definition of economic connectedness: two times the share of
# high-SES friends among low-SES individuals, averaged over all low-SES
# individuals in the county.

library(tidyverse)
library(usethis)

# There is a lot more that we could do with this data. Indeed, there is an
# argument that we should be focussing on the zip code, college or high school
# data. But not today.

# Defaults work well, except for county, which is a code, not a name. (Might be
# that it should still be an integer, because that is the standard usage in this
# literature.)

x <- read_csv("data-raw/social_capital_county.csv",
              col_types = cols(county = col_character())) |>

  # Note that I leave the location includes the county name and state. I could
  # fix that here, but I prefer to leave this as an exercise for students. We
  # might add more variables to this tibble later, but, for now, all I want is
  # something convenient for the bootcamp course.

  select(location = county_name,
         population = pop2018,
         connectedness = ec_county)

# At some point, I want to add adult income to this data set, the better to
# replicate some of the cool graphics associated with the NYT article. Why isn't
# income data included in this data? I don't know!

# For now, here are some thoughts from previous work.

# There is a county_outcomes.csv data which we might download from
# https://opportunityinsights.org/data/, listed under "Social Capital Data by
# County." Within that data , items like kir_pooled_pooled_mean or
# kfr_pooled_pooled_mean might be what we need.

# Save the data.

connectedness <- x

usethis::use_data(connectedness, overwrite = TRUE)






