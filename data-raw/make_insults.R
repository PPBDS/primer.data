
library(tidyverse)
library(magrittr)



# Below is some code to prepare ready-made data from Kaggle. I can do this in a
# better way. Read in data from Trump Twitter Archive:

x <- read_csv("data-raw/trump_tweets.csv")


# Rename 'text' to 'tweet', remove everything but 'tweet' and 'date'.

x %<>%
  rename(tweet = text) %>%
  select(tweet, date)


# Convert from dttm to date variable.

x %<>%
  mutate()











# There is a database with all Trump tweets (https://www.thetrumparchive.com/),
# The New York Times has used this to extract what they consider insults
# (https://www.nytimes.com/interactive/2021/01/19/upshot/trump-complete-insult-list.html),
# and someone has scraped the data and published it on kaggle in a usable format
# (https://www.kaggle.com/ayushggarg/all-trumps-twitter-insults-20152021). It
# seems like the dataset from Kaggle does not contain all entries from NYT, but
# there is no scientific definition of an insult anyway. I guess he used some
# algorithm, since not all of the NYT entries are actually insults. Might
# implement this myself someday. Just thought this might be fun for future ML
# tutorials. The last link is where I got this. Contains tweets from 2015 to
# # 2021. Start by reading in the data. The first variable is garbage.
#
# x <- read_csv("data-raw/trump_insults.csv", quote = "\\\"") %>%
#       select(-1)
#
#
# # Fix variable names. The initial ones had double quotes around them, so
# # rename() would require escaping stuff. This is easier.
#
# names(x) <- c("date", "target", "insult", "tweet")
#
#
# # Remove missing rows. This keeps giving me warnings, but the warning message is
# # always empty. Is this a bug?
#
# x %<>%
#   filter(is.na(tweet) == FALSE)
#
#
# # Remove double quotes around strings and remove '-' in target
# # variable.
#
# x %<>%
#   mutate(date = gsub('[\"]', '', date),
#          target = gsub('[\"]', '', target),
#          insult = gsub('[\"]', '', insult),
#          tweet = gsub('[\"]', '', tweet),
#          target = str_replace_all(target, '-', ' '))
#
#
# # Remove tweets before Jun 14, 2015. I don't know why this is in here,
#
#
# # Adjust variable type for 'date'.
#
# x %<>%
#   mutate(date = as.Date(date))
#
#
# # Save data.
#
# insults <- x
#
# usethis::use_data(insults, overwrite = TRUE)
#

