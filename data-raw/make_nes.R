library(tidyverse)
library(haven)
library(usethis)

# ==============================================================================
# OVERVIEW AND DATA SOURCES
# ==============================================================================

# This script processes data from the American National Election Survey (ANES), 
# a project that aims to provide insights into voter behavior. ANES has been 
# running since 1948 before and after each presidential election, and is run by 
# academics at UMich and Stanford. The survey combines questions about voters' 
# political attitudes with extensive biographical information.

# We combine two datasets:
# 1. ANES Time Series Cumulative Data File (1948-2020): Historical data
# 2. ANES 2024 Time Series Study: Most recent election data

# We combine the datasets since currently there is no cumulative data from 1948-2024.
# We had to manually integrate 2024 into the existing 1948-2020 data.

# Details about ANES and raw data: https://electionstudies.org/data-center/

# The raw zip files are in the repo. Derived files are too big to commit, so we 
# unzip, read, and then delete the temporary files.

# ==============================================================================
# IMPORT DATA
# ==============================================================================

# Import cumulative data (1948-2020)
unzip("data-raw/anes_timeseries_cdf_stata_20220916.zip")
cumulative <- read_dta("anes_timeseries_cdf_stata_20220916.dta")
stopifnot(all(file.remove(c("anes_timeseries_cdf_stata_20220916.dta",
                            "anes_timeseries_cdf_codebook_app_20220916.pdf",
                            "anes_timeseries_cdf_codebook_var_20220916.pdf"))))

# Import 2024 data
unzip("data-raw/anes_timeseries_2024_csv_20250808.zip")
y2024 <- read.csv("anes_timeseries_2024_csv_20250808.csv")
stopifnot(all(file.remove(c("anes_timeseries_2024_csv_20250808.csv",
                            "anes_timeseries_2024_userguidecodebook_20250808.pdf"))))

# Import FIPS codes for state mapping
fips_key <- read.csv("data-raw/fips_key.csv") |>
  select(fips, state_abbr)

# Select only the variables we need from each dataset
cumulative <- cumulative |>
  # Only retain presidential election years
  filter(VCF0004 %in% seq(1948, max(cumulative$VCF0004), by = 4)) |>
  # Filter out 1948 observations (lacking data on several variables)
  filter(VCF0004 > 1948) |>
  # Select relevant variables
  select(VCF0004,    # year
         VCF0901a,   # state FIPS code  
         VCF0104,    # sex
         VCF0114,    # income
         VCF0101,    # age
         VCF0140a,   # education
         VCF0105a,   # race
         VCF0301,    # ideology/party identification
         VCF0702,    # voted in national elections
         VCF0112,    # region
         VCF0450,    # president approval
         VCF0613,    # influence (people like R have say in government)
         VCF9013,    # equality (society should ensure equal opportunity)
         VCF0846,    # religion importance
         VCF0823,    # better alone (US better off alone)
         VCF0206,    # thermometer blacks
         VCF0207,    # thermometer whites
         VCF0704)    # presidential vote

y2024 <- y2024 |>
  select(V242058x,   # state
         V241550,    # sex  
         V241458x,   # age
         V241465x,   # education
         V241501x,   # race
         V242065,    # voted
         V243007,    # region
         V241075x,   # presidential vote
         V241227x,    # ideology (party identification)
         V242201,    # influence (people like R have say in government)
         V242254,    # equality (society should ensure equal opportunity)
         V241420,    # religion importance
         V241312x,   # better alone (US better off alone)
         V242516,    # thermometer blacks
         V242518,    # thermometer whites
         V241137x,   # president approval
         V241566x)   # income

# ==============================================================================
# RENAME 2024 VARIABLES TO MATCH CUMULATIVE NAMES
# ==============================================================================

# GROUP 1: Straightforward renames (100% consistent mappings)
# These variables have clear, direct mappings between the two datasets

y2024 <- y2024 |>
  rename(
    # Basic demographics - these are consistently measured across years
    VCF0104 = V241550,    # sex (Male/Female categories consistent)
    VCF0101 = V241458x,   # age (continuous variable, same measurement)
    VCF0112 = V243007,    # region (Northeast/Midwest/South/West consistent)
    VCF0702 = V242065,    # voted (Yes/No response consistent)
    VCF0901a = V242058x,  # state FIPS (standardized codes)
    VCF0301 = V241227x,    # party identification
    VCF0613 = V242201,    # influence
    VCF9013 = V242254,    # equality
    VCF0846 = V241420,    # religion importance
    VCF0823 = V241312x,   # better alone
    VCF0206 = V242516,    # thermometer blacks
    VCF0207 = V242518,    # thermometer whites
    VCF0450 = V241137x,   # president approval
    VCF0114 = V241566x    # income
  ) |>
  # Add year variable
  mutate(VCF0004 = 2024L)

# GROUP 2: Problematic renames (require careful consideration)
# These variables have some inconsistencies or measurement changes over time
# but we're mapping them to maintain historical comparability

y2024 <- y2024 |>
  rename(
    # Education: 2024 has 5 categories vs historical 7 categories
    # We lose granularity (no "Elementary" or "Highschool +" in 2024)
    # but maintain general educational progression
    VCF0140a = V241465x,
    
    # Race: Categories have evolved over time
    # 2024 uses more modern racial/ethnic classifications
    # Historical data includes "Non-white"/"Other" that 2024 doesn't
    # We're mapping for best approximate consistency
    VCF0105a = V241501x,
    
    # Presidential vote: 2024 combines actual votes with voting intentions
    # Historical data may have been more restrictive about actual votes
    # We're creating a unified "vote choice" variable that includes intentions
    VCF0704 = V241075x
  )

# Missing variables in 2024 data that exist in cumulative:
# All major variables now included and mapped

# ==============================================================================
# CLEAN AND STANDARDIZE CUMULATIVE DATA
# ==============================================================================

cumulative <- cumulative |>
  
  # Clean year variable
  mutate(year = as.integer(VCF0004)) |>
  select(-VCF0004) |>
  
  # Clean sex variable
  mutate(VCF0104 = as.character(as_factor(VCF0104))) |>
  separate(VCF0104, into = c(NA, "sex"), sep = "[.]") |>
  mutate(sex = case_when(
    sex == " Female" ~ "Female",
    sex == " Male" ~ "Male",
    sex == " Other (2016)" ~ "Other")) |>
    
  # Clean income variable (factor to preserve ordinality)
  mutate(VCF0114 = as.character(as_factor(VCF0114))) |>
  separate(VCF0114, into = c(NA, "income"), sep = "[.]") |>
  mutate(income = as.factor(case_when(
    income == " 96 to 100 percentile" ~ "96 - 100",
    income == " 68 to 95 percentile" ~ "68 - 95", 
    income == " 34 to 67 percentile" ~ "34 - 67",
    income == " 17 to 33 percentile" ~ "17 - 33",
    income == " 0 to 16 percentile" ~ "0 - 16"))) |>
    
  # Clean race variable  
  mutate(VCF0105a = as.character(as_factor(VCF0105a))) |>
  mutate(race = as.character(case_when(
    str_extract(VCF0105a, pattern = "White") == "White" ~ "White",
    str_extract(VCF0105a, pattern = "Black") == "Black" ~ "Black", 
    str_extract(VCF0105a, pattern = "Asian") == "Asian" ~ "Asian",
    str_extract(VCF0105a, pattern = "Indian") == "Indian" ~ "Native American",
    ((str_extract(VCF0105a, pattern = "Hispanic") == "Hispanic") &
       str_detect(VCF0105a, pattern = "non-") == FALSE) ~ "Hispanic",
    str_extract(VCF0105a, pattern = "Other") == "Other" ~ "Other",
    str_extract(VCF0105a, pattern = "Non-white") == "Non-white" ~ "Other",
    TRUE ~ NA_character_))) |>
  select(-VCF0105a) |>
  
  # Clean ideology variable and create numeric version
  mutate(VCF0301 = as_factor(VCF0301)) |>
  mutate(VCF0301 = as.character(VCF0301)) |>
  mutate(ideology = str_sub(VCF0301, start = 4, end = -1)) |>
  select(-VCF0301) |>
  mutate(ideology = factor(ideology,
                           levels = c("Strong Democrat",
                                      "Weak Democrat", 
                                      "Independent - Democrat",
                                      "Independent - Independent",
                                      "Independent - Republican",
                                      "Weak Republican",
                                      "Strong Republican"))) |>
  # Create 7-point ideology scale (1 = Strong Democrat, 7 = Strong Republican)
  mutate(ideology_numeric = as.numeric(ideology)) |>
  
  # Clean education variable
  mutate(VCF0140a = as.character(as_factor(VCF0140a))) |>
  mutate(education = as.character(case_when(
    str_extract(VCF0140a, pattern = "1. ") == "1. " ~ "Elementary",
    str_extract(VCF0140a, pattern = "2. ") == "2. " ~ "Some Highschool", 
    str_extract(VCF0140a, pattern = "3. ") == "3. " ~ "Highschool",
    str_extract(VCF0140a, pattern = "4. ") == "4. " ~ "Highschool +",
    str_extract(VCF0140a, pattern = "5. ") == "5. " ~ "Some College",
    str_extract(VCF0140a, pattern = "6. ") == "6. " ~ "College", 
    str_extract(VCF0140a, pattern = "7. ") == "7. " ~ "Adv. Degree",
    TRUE ~ NA_character_))) |>
  mutate(education = factor(education,
                       levels = c("Elementary", "Some Highschool",
                                  "Highschool", "Highschool +", 
                                  "Some College", "College",
                                  "Adv. Degree"))) |>
  select(-VCF0140a) |>
  
  # Clean state variable and join with FIPS key
  mutate(fips = as.integer(as.character(VCF0901a))) |>
  select(-VCF0901a) |>
  left_join(fips_key, by = "fips") |>
  mutate(state = state_abbr) |>
  select(-fips, -state_abbr) |>
  
  # Clean region variable
  mutate(region = as.factor(case_when(VCF0112 == 1 ~ "Northeast",
                                      VCF0112 == 2 ~ "Midwest", 
                                      VCF0112 == 3 ~ "South",
                                      VCF0112 == 4 ~ "West"))) |>
  select(-VCF0112) |>
  
  # Clean voted variable
  mutate(voted = as_factor(VCF0702)) |>
  separate(col = voted, into = c("voted", "v2"), sep = "[.]") |>
  mutate(voted = as.character(case_when(
             str_extract(v2, pattern = "voted") == "voted" ~ "Yes",
             str_extract(v2, pattern = "not") == "not" ~ "No", 
             TRUE ~ NA_character_))) |>
  select(-VCF0702, -v2) |>
  
  # Clean age variable
  mutate(age = as.integer(VCF0101)) |>
  select(-VCF0101) |>
  
  # Clean presidential approval variable
  mutate(pres_appr = as_factor(VCF0450)) |>
  mutate(pres_appr = as.character(case_when(
    str_detect(pres_appr, "1. ") == TRUE ~ "Approve",
    str_detect(pres_appr, "2. ") == TRUE ~ "Disapprove", 
    str_detect(pres_appr, "8. ") == TRUE ~ "Unsure",
    TRUE ~ NA_character_))) |>
  select(-VCF0450) |>
  
  # Clean thermometer variables
  mutate(therm_black = as.integer(VCF0206)) |>
  mutate(therm_white = as.integer(VCF0207)) |>
  select(-VCF0206, -VCF0207) |>
  
  # Clean "better alone" variable
  mutate(better_alone = as.character(as_factor(VCF0823)),
         better_alone = case_when(
           better_alone == "1. Agree (1956-1960: incl. 'agree strongly' and 'agree" ~ "Agree",
           better_alone == "2. Disagree (1956-1960: incl. 'disagree strongly' and" ~ "Disagree",
           TRUE ~ NA_character_)) |>
  select(-VCF0823) |>
  
  # Clean religious importance variable
  mutate(religion = as.character(as_factor(VCF0846)),
         religion = case_when(
           religion == "1. Yes, important" ~ "Important",
           religion == "2. No, not important" ~ "Unimportant", 
           religion == "8. DK" ~ "Don't know",
           TRUE ~ NA_character_)) |>
  select(-VCF0846) |>
  
  # Clean equality variable
  mutate(equality = as.character(as_factor(VCF9013)),
         equality = case_when(
           equality == "1. Agree strongly" ~ "Agree strongly",
           equality == "2. Agree somewhat" ~ "Agree somewhat",
           equality == "3. Neither agree nor disagree" ~ "Neither agree nor disagree", 
           equality == "4. Disagree somewhat" ~ "Disagree somewhat",
           equality == "5. Disagree strongly" ~ "Disagree strongly",
           equality == "8. DK" ~ "Don't know",
           TRUE ~ NA_character_)) |>
  select(-VCF9013) |>
  
  # Clean influence variable
  mutate(influence = as.character(as_factor(VCF0613)),
         influence = case_when(
           influence == "1. Agree" ~ "Agree",
           influence == "2. Disagree" ~ "Disagree",
           influence == "3. Neither agree nor disagree (1988 and later only)" ~ "Neither agree nor disagree",
           TRUE ~ NA_character_)) |>
  select(-VCF0613) |>
  
  # Clean presidential vote variable
  mutate(pres_vote = as.integer(VCF0704)) |>
  mutate(pres_vote = case_when(
    pres_vote == 1 ~ "Democrat",
    pres_vote == 2 ~ "Republican", 
    pres_vote == 3 ~ "Third Party")) |>
  select(-VCF0704) |>
  
  # Select final variables in desired order
  select(year, state, sex, income, age,
         education, race, ideology, ideology_numeric, voted,
         region, pres_appr, influence, equality,
         religion, better_alone, therm_black,
         therm_white, pres_vote)

# ==============================================================================  
# CLEAN AND STANDARDIZE 2024 DATA
# ==============================================================================

y2024 <- y2024 |>
  
  # Add year
  mutate(year = 2024L) |>
  
  # Clean state variable using FIPS mapping
  mutate(fips = case_when(
    VCF0901a == 1 ~ 1L,   VCF0901a == 2 ~ 2L,   VCF0901a == 4 ~ 4L,   VCF0901a == 5 ~ 5L,
    VCF0901a == 6 ~ 6L,   VCF0901a == 8 ~ 8L,   VCF0901a == 9 ~ 9L,   VCF0901a == 10 ~ 10L,
    VCF0901a == 11 ~ 11L, VCF0901a == 12 ~ 12L, VCF0901a == 13 ~ 13L, VCF0901a == 15 ~ 15L,
    VCF0901a == 16 ~ 16L, VCF0901a == 17 ~ 17L, VCF0901a == 18 ~ 18L, VCF0901a == 19 ~ 19L,
    VCF0901a == 20 ~ 20L, VCF0901a == 21 ~ 21L, VCF0901a == 22 ~ 22L, VCF0901a == 23 ~ 23L,
    VCF0901a == 24 ~ 24L, VCF0901a == 25 ~ 25L, VCF0901a == 26 ~ 26L, VCF0901a == 27 ~ 27L,
    VCF0901a == 28 ~ 28L, VCF0901a == 29 ~ 29L, VCF0901a == 30 ~ 30L, VCF0901a == 31 ~ 31L,
    VCF0901a == 32 ~ 32L, VCF0901a == 33 ~ 33L, VCF0901a == 34 ~ 34L, VCF0901a == 35 ~ 35L,
    VCF0901a == 36 ~ 36L, VCF0901a == 37 ~ 37L, VCF0901a == 38 ~ 38L, VCF0901a == 39 ~ 39L,
    VCF0901a == 40 ~ 40L, VCF0901a == 41 ~ 41L, VCF0901a == 42 ~ 42L, VCF0901a == 44 ~ 44L,
    VCF0901a == 45 ~ 45L, VCF0901a == 46 ~ 46L, VCF0901a == 47 ~ 47L, VCF0901a == 48 ~ 48L,
    VCF0901a == 49 ~ 49L, VCF0901a == 50 ~ 50L, VCF0901a == 51 ~ 51L, VCF0901a == 53 ~ 53L,
    VCF0901a == 54 ~ 54L, VCF0901a == 55 ~ 55L, VCF0901a == 56 ~ 56L,
    TRUE ~ NA_integer_)) |>
  select(-VCF0901a) |>
  left_join(fips_key, by = "fips") |>
  mutate(state = state_abbr) |>
  select(-fips, -state_abbr) |>
  
  # Clean sex variable  
  mutate(sex = case_when(
    VCF0104 == 1 ~ "Male",
    VCF0104 == 2 ~ "Female",
    TRUE ~ NA_character_)) |>
  select(-VCF0104) |>
  
  # Clean age variable
  mutate(age = case_when(
    VCF0101 < 0 ~ NA_integer_,
    TRUE ~ as.integer(VCF0101))) |>
  select(-VCF0101) |>
  
  # Clean education variable
  mutate(education = as.character(case_when(
    VCF0140a == 1 ~ "Some Highschool",    # Less than high school
    VCF0140a == 2 ~ "Highschool",         # High school credential  
    VCF0140a == 3 ~ "Some College",       # Some post-high school, no bachelor's
    VCF0140a == 4 ~ "College",            # Bachelor's degree
    VCF0140a == 5 ~ "Adv. Degree",        # Graduate degree
    TRUE ~ NA_character_))) |>
  mutate(education = factor(education,
                       levels = c("Elementary", "Some Highschool",
                                  "Highschool", "Highschool +",
                                  "Some College", "College", 
                                  "Adv. Degree"))) |>
  select(-VCF0140a) |>
  
  # Clean race variable
  mutate(race = as.character(case_when(
    VCF0105a == 1 ~ "White",              # White, non-Hispanic
    VCF0105a == 2 ~ "Black",              # Black, non-Hispanic
    VCF0105a == 3 ~ "Hispanic",           # Hispanic  
    VCF0105a == 4 ~ "Asian",              # Asian or Native Hawaiian/Pacific Islander
    VCF0105a == 5 ~ "Native American",    # Native American/Alaska Native or other
    VCF0105a == 6 ~ "Other",              # Multiple races, non-Hispanic
    TRUE ~ NA_character_))) |>
  select(-VCF0105a) |>
  
  # Clean voted variable
  mutate(voted = case_when(
    VCF0702 == 4 ~ "Yes",     # Yes, voted
    VCF0702 %in% c(1, 2, 3) ~ "No",      # No, have not voted (various reasons)
    VCF0702 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF0702) |>
  
  # Clean region variable
  mutate(region = as.factor(case_when(
    VCF0112 == 1 ~ "Northeast",
    VCF0112 == 2 ~ "Midwest",
    VCF0112 == 3 ~ "South", 
    VCF0112 == 4 ~ "West",
    TRUE ~ NA_character_))) |>
  select(-VCF0112) |>
  
  # Clean presidential vote variable
  # Combining actual votes, intent to vote, and preferences
  mutate(pres_vote = case_when(
    VCF0704 %in% c(10, 20, 30) ~ "Democrat",    # Democratic (vote/intent/preference)
    VCF0704 %in% c(11, 21, 31) ~ "Republican",  # Republican (vote/intent/preference) 
    VCF0704 %in% c(12, 22, 32) ~ "Third Party", # Other (vote/intent/preference)
    TRUE ~ NA_character_)) |>
  select(-VCF0704) |>
  
  # Clean party identification/ideology variable (V241227x -> V242201)
  mutate(ideology = case_when(
    VCF0301 == 1 ~ "Strong Democrat",
    VCF0301 == 2 ~ "Weak Democrat",
    VCF0301 == 3 ~ "Independent - Democrat",
    VCF0301 == 4 ~ "Independent - Independent",
    VCF0301 == 5 ~ "Independent - Republican", 
    VCF0301 == 6 ~ "Weak Republican",
    VCF0301 == 7 ~ "Strong Republican",
    VCF0301 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  mutate(ideology = factor(ideology, levels = c("Strong Democrat", "Weak Democrat",
                                                "Independent - Democrat", "Independent - Independent", 
                                                "Independent - Republican", "Weak Republican",
                                                "Strong Republican"))) |>
  mutate(ideology_numeric = as.numeric(ideology)) |>
  select(-VCF0301) |>
  
  # Clean presidential approval variable (V241137x)
  mutate(pres_appr = case_when(
    VCF0450 %in% c(1, 2) ~ "Approve",    # Approve strongly/somewhat
    VCF0450 %in% c(3, 4) ~ "Disapprove", # Disapprove somewhat/strongly
    VCF0450 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF0450) |>
  
  # Clean influence variable (V242201)
  mutate(influence = case_when(
    VCF0613 %in% c(1, 2) ~ "Agree",      # Agree strongly/somewhat
    VCF0613 == 3 ~ "Neither agree nor disagree",
    VCF0613 %in% c(4, 5) ~ "Disagree",   # Disagree somewhat/strongly
    VCF0613 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF0613) |>
  
  # Clean equality variable (V242254)
  mutate(equality = case_when(
    VCF9013 == 1 ~ "Agree strongly",
    VCF9013 == 2 ~ "Agree somewhat", 
    VCF9013 == 3 ~ "Neither agree nor disagree",
    VCF9013 == 4 ~ "Disagree somewhat",
    VCF9013 == 5 ~ "Disagree strongly",
    VCF9013 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF9013) |>
  
  # Clean religion variable (V241420)
  mutate(religion = case_when(
    VCF0846 %in% c(1, 2, 3, 4) ~ "Important",    # Very/quite/somewhat/slightly important
    VCF0846 == 5 ~ "Unimportant",                # Not important at all
    VCF0846 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF0846) |>
  
  # Clean better alone variable (V241312x)
  mutate(better_alone = case_when(
    VCF0823 %in% c(1, 2) ~ "Agree",      # Agree strongly/somewhat
    VCF0823 %in% c(3, 4) ~ "Disagree",   # Disagree somewhat/strongly
    VCF0823 < 0 ~ NA_character_,
    TRUE ~ NA_character_)) |>
  select(-VCF0823) |>
  
  # Clean thermometer variables (V242516, V242518)
  mutate(therm_black = case_when(
    VCF0206 >= 0 & VCF0206 <= 100 ~ as.integer(VCF0206),
    TRUE ~ NA_integer_)) |>
  select(-VCF0206) |>
  
  mutate(therm_white = case_when(
    VCF0207 >= 0 & VCF0207 <= 100 ~ as.integer(VCF0207),
    TRUE ~ NA_integer_)) |>
  select(-VCF0207) |>
  
  # Clean income variable - map 2024 categories to percentile ranges
  # Based on typical US income distribution, approximate mapping:
  # Bottom 16%: Under $25K, 17-33%: $25-45K, 34-67%: $45-90K, 68-95%: $90-175K, 96-100%: $175K+
  mutate(income = case_when(
    VCF0114 %in% c(1:9) ~ "0 - 16",        # Under $5K to $27.5-29.9K (bottom ~16%)
    VCF0114 %in% c(10:14) ~ "17 - 33",     # $30-34.9K to $45-49.9K (next ~17%)  
    VCF0114 %in% c(15:21) ~ "34 - 67",     # $50-54.9K to $80-89.9K (middle ~34%)
    VCF0114 %in% c(22:26) ~ "68 - 95",     # $90-99.9K to $150-174.9K (upper middle ~27%)
    VCF0114 %in% c(27:28) ~ "96 - 100",    # $175K+ (top ~4%)
    VCF0114 < 0 ~ NA_character_,            # Negative values = missing
    TRUE ~ NA_character_)) |>
  mutate(income = factor(income, levels = c("0 - 16", "17 - 33", "34 - 67", 
                                            "68 - 95", "96 - 100"))) |>
  select(-VCF0114) |>
  
  # Select final variables in same order as cumulative
  select(year, state, sex, income, age,
         education, race, ideology, ideology_numeric, voted,
         region, pres_appr, influence, equality, 
         religion, better_alone, therm_black,
         therm_white, pres_vote)

# ==============================================================================
# COMBINE DATASETS AND FINAL CHECKS
# ==============================================================================

# Combine the datasets
nes <- bind_rows(cumulative, y2024)

# Data quality checks
stopifnot(nrow(cumulative) > 32000)      # Check cumulative data size
stopifnot(length(levels(cumulative$education)) == 7)  # Check education levels
stopifnot(is.integer(cumulative$year))   # Check year format
stopifnot(dim(table(cumulative$income, useNA = "no")) == 5)  # Check income categories (excluding NAs)
stopifnot(is.numeric(cumulative$ideology_numeric))  # Check ideology numeric variable
stopifnot(is.integer(cumulative$age))    # Check age format
stopifnot(nrow(y2024) > 0)               # Check 2024 data exists
stopifnot(max(nes$year, na.rm = TRUE) == 2024)  # Check 2024 data included

# Save the final dataset
usethis::use_data(nes, overwrite = TRUE)