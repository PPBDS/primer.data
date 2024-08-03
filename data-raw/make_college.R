library(tidyverse)

# This dataset is from Barfort, Klemmensen & Larsen (2019), and was originally
# used in a paper published in Political Science and Research Methods. Details
# of the study can be accessed at https://doi.org/10.1017/psrm.2019.63, the raw
# data used here is available at https://doi.org/10.7910/DVN/IBKYRX.

# Reading in the data. I excluded variables that indicate a candidate's middle
# name ("cand_middle"), and  whether a candidate was living at the time the
# study was conducted ("living"). Neither variable provides meaningful insights,
# and excluding them keeps the dataset concise. Also, I excluded variables
# indicating annual increases in per capita income ("pc_inc_ann"), total
# expenditures ("tot_expenditure"), and life expectancy of a candidate in
# remaining years ("ex"). These variables may be interesting, but have way too
# many NAs to be useful. Finally, I excluded four variables indicating the the
# census region in which an election took place ("reg_south", "reg_west",
# "reg_midwest", "reg_northeast"). This adds little information, given that we
# already have a variable indicating the federal state in which an election took
# place.

# What is the `ex` variable? Looks interesting.

# Key variables are days lived before (living_day_imp_pre, living_day_pre) and
# after (living_day_imp_post, living_day_post) the election. Note that there are
# two versions of both, with one --- with "imp" in the name --- indicating that
# it has been imputed. They look highly similar, with a few less missing among
# the imputed. So, I will just use those, and out them into years rather than
# days for measurement.


# How accurate is this data? At random, I looked at Massachusetts and found two
# years (1908, 1909) with only one candidate (Republican Eben Draper). Yet,
# Wikipedia tells me that in 1908 and 1909 James H. Vahey ran against Draper.
# Indeed, in 1909, there was an Independence Party candidate, William Osgood,
# who got more than 5% of the vote. I have similar concerns about the 1854
# election in New York, where only 1 of the four candidates who got more than 5%
# of the vote is listed.  But there are (probably!) not enough omissions like
# this to change the results . . .

# Also, other data seems wrong. For example, David Williams, candidate for
# Governor in Kentucky in 2011 is listed with a death date of 2016-01-01, but
# Wikipedia lists him as alive. Other recent deaths check out. So, no worries?

x <- read_csv("data-raw/mrc_table10.csv") %>%

  # selecting variables to be used

  select(name,
         region,
         state,
         county,
         zip,
         tier,
         tier_name,
         type,
         iclevel,
         barrons,
         hbcu,
         ipeds_enrollment_2013,
         sticker_price_2013,
         grad_rate_150_p_2013,
         avgfacsal_2013,
         sat_avg_2013,
         asian_or_pacific_share_fall_2000,
         black_share_fall_2000,
         hisp_share_fall_2000,
         alien_share_fall_2000,
         pct_arthuman_2000,
         pct_business_2000,
         pct_health_2000,
         pct_multidisci_2000,
         pct_publicsocial_2000,
         pct_stem_2000,
         pct_tradepersonal_2000,
         pct_socialscience_2000) %>%

# Renaming some variables

  rename(degree_offering = "iclevel",
         selectivity = "barrons",
         enrollment = "ipeds_enrollment_2013",
         cost = "sticker_price_2013",
         grad_rate = "grad_rate_150_p_2013",
         faculty_sal = "avgfacsal_2013",
         sat = "sat_avg_2013",
         pct_asian_pacific = "asian_or_pacific_share_fall_2000",
         pct_black = "black_share_fall_2000",
         pct_hispanic = "hisp_share_fall_2000",
         pct_international = "alien_share_fall_2000",
         pct_arthuman = "pct_arthuman_2000",
         pct_business = "pct_business_2000",
         pct_med = "pct_health_2000",
         pct_multidisci = "pct_multidisci_2000",
         pct_publicsocial = "pct_publicsocial_2000",
         pct_stem = "pct_stem_2000",
         pct_socialscience = "pct_socialscience_2000",
         pct_tradepersonal = "pct_tradepersonal_2000") %>%

# Creating a new variable `acceptance_rate`.

# Editing selectivity, degree_offering, region and type to display text instead of numbers

  mutate(selectivity = case_when(selectivity == 1 ~ "Elite",
                                 selectivity == 2 ~ "Highly Selective",
                                 selectivity == 3 ~ "Selective",
                                 selectivity == 4 ~ "Moderately Selective",
                                 selectivity == 5 ~ "Moderately Selective",
                                 selectivity == 9 ~ "Special",
                                 selectivity == 999 ~ "Non-selective")) %>%

  mutate(degree_offering = case_when(degree_offering == 1 ~ "Four-year",
                                     degree_offering == 2 ~ "Two-year",
                                     degree_offering == 2 ~ "Less than two-year")) %>%

  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West")) %>%

  mutate(type = case_when(type == 1 ~ "public",
                          type == 2 ~ "private non-profit",
                          type == 3 ~ "private for-profit")) %>%

# Turning `hbcu` into a binary variable

  mutate(hbcu = case_when(hbcu == 0 ~ FALSE,
                          hbcu == 1 ~ TRUE))


