library(tidyverse)

# This dataset is from Voteview, a website by political scientists Keith Poole
# and Howard Rosenthal that freely provides information on congressional roll
# calls votes in the U.S. The data starts with the first U.S. congress in 1789,
# and includes votes from both the Senate and the House of Representatives. The focus here is
# on the 'nominate' variables included in Voteview's datasets, which provide
# information on the ideological positions of voting Senators and Representatives.
# The raw data used here can be accessed at
# https://voteview.com/data.

# Reading in the data. I excluded variables that represent internal IDs the researchers
# assigned to individual politicians ("icpsr"), states ("state_icpsr"), and politians'
# bioguides ("bioguide_id"), as well as their occupancy ("occupancy"). These variables
# provide little to no meaningful insights, or, in the case of "occupancy", are not very
# detailed. Furthermore, I also excluded several variables that are related to the "nominate"
# estimation method or other estimation procedures, namely "nominate_log_likelihood",
# "nominate_geo_mean_probability", "nominate_number_of_votes", "nominate_number_of_errors",
# "conditional", "nokken_poole_dim1", and "nokken_poole_dim2". Some of these may be insightful,
# but we do not want to overwhelm people.

x <- read_csv("data-raw/HSall_members.csv",
              col_types = cols(congress = col_integer(),
                               chamber = col_character(),
                               state_abbrev = col_character(),
                               party_code = col_character(),
                               bioname = col_character(),

                               # Although the year of birth is an integer, I decided to parse it as a
                               # double. For a few politicians, such as George Washington, the dataset
                               # does not contain the year of birth, and parsing it as integer resulted
                               # in NAs in *every* observation. By parsing it as double, the data will
                               # not be affected.

                               born = col_double(),

                               # Similar problem as with the year of birth, except that there are many
                               # more NAs. Remember that the data also includes recent congresses, with
                               # many members not yet deceased.

                               died = col_double(),

                               nominate_dim1 = col_double(),
                               nominate_dim2 = col_double())) %>%


 # Selecting variables to be used.

    select(congress, chamber,
           state_abbrev, party_code,
           bioname, born,
           died, nominate_dim1,
           nominate_dim2) %>%


 # Renaming some variables.

  rename(state = state_abbrev,
         party = party_code,
         name = bioname) %>%


  # Recoding names and internal party codes.

  mutate(name = str_to_title(name),
         party = recode(party,
                        `100` = "Democrat",
                        `200` = "Republican",

                        `328` =	"Independent",
                        `329` =	"Independent Democrat",
                        `331` = "Independent Republican",
                        `603` =	"Independent Whig",

                          `1` = "Federalist",
                         `13` = "Democratic-Republican",
                         `22` = "Adams",
                         `26` = "Anti Masonic",
                         `29` = "Whig",
                         `37` = "Constitutional Unionist",
                         `44` = "Nullifier",
                         `46` = "States Rights",
                        `108` = "Anti-Lecompton Democrat",
                        `112` =	"Conservative",
                        `114` = "Readjuster",
                        `117` = "Readjuster Democrat",
                        `203` =	"Unconditional Unionist",
                        `206` =	"Unionist",
                        `208` =	"Liberal Republican",
                        `213` = "Progressive Republican",
                        `300` =	"Free Soil",
                        `310` =	"American",
                        `326` =	"National Greenbacker",
                        `340` =	"Populist",
                        `347` =	"Prohibitionist",
                        `354` =	"Silver Republican",
                        `355` =	"Union Labor",
                        `356` =	"Union Labor",
                        `370` =	"Progressive",
                        `380` =	"Socialist",
                        `402` =	"Liberal",
                        `403` =	"Law and Order",
                        `522` =	"American Labor",
                        `523` =	"American Labor (La Guardia)",
                        `537` =	"Farmer-Labor",
                        `555` =	"Jackson",
                       `1060` = "Silver",
                       `1111` =	"Liberty",
                       `1116` =	"Conservative Republicans",
                       `1275` =	"Anti-Jacksonians",
                       `1346` =	"Jackson Republican",
                       `3333` = "Opposition",
                       `3334` =	"Opposition (36th)",
                       `4000` =	"Anti-Administration",
                       `4444` =	"Constitutional Unionist",
                       `5000` =	"Pro-Administration",
                       `6000` =	"Crawford Federalist",
                       `7000` =	"Jackson Federalist",
                       `7777` =	"Crawford Republican",
                       `8000` =	"Adams-Clay Federalist",
                       `8888` =	"Adams-Clay Republican",

                       .default = "Other"))


# Checking whether any column includes the same value for every observation.
# I tried to automate the first type of check, but using a function including
# a for-loop caused me some problems. Need to work on a universally applicable
# function for this.

stopifnot(length(levels(factor(x$congress))) != 1)
stopifnot(length(levels(factor(x$chamber))) != 1)
stopifnot(length(levels(factor(x$state))) != 1)
stopifnot(length(levels(factor(x$party))) != 1)
stopifnot(length(levels(factor(x$name))) != 1)
stopifnot(length(levels(factor(x$born))) != 1)
stopifnot(length(levels(factor(x$died))) != 1)
stopifnot(length(levels(factor(x$nominate_dim1))) != 1)
stopifnot(length(levels(factor(x$nominate_dim2))) != 1)


# Checking whether any row includes the same value for every
# variable. This is particurly useful to check if, for whatever
# reason, the dataset includes observations that consist of only NAs.
# Again, try to make this a function.

df <- x
df$unique <- !(duplicated(x) | duplicated(x, fromLast = TRUE))
df <- df %>%
  filter(unique == FALSE)
stopifnot(nrow(df) == 0)


# Save.

nominate <- x

usethis::use_data(nominate, overwrite = TRUE)

