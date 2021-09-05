
# CODE TO CREATE CURRENT DATA:

library(tidyverse)
library(magrittr)
library(janitor)
library(parallel)
library(doParallel)
library(foreach)

# There is a database with all Trump tweets (https://www.thetrumparchive.com/),
# The New York Times has used this to extract what they consider insults
# (https://www.nytimes.com/interactive/2021/01/19/upshot/trump-complete-insult-list.html),
# and someone has scraped the data and published it on kaggle in a usable format
# (https://www.kaggle.com/ayushggarg/all-trumps-twitter-insults-20152021). It
# seems like the dataset from Kaggle does not contain all entries from NYT, but
# there is no scientific definition of an insult anyway. I guess he used some
# algorithm, since not all of the NYT entries are actually insults. Might
# implement this myself someday. Just thought this might be fun for future ML
# tutorials. The last link is where I got this. Contains tweets from 2014 to
# 2021. Start by reading in the data. The first variable is garbage.

x <- read_csv("data-raw/trump_insults.csv", quote = "\\\"") %>%
      select(-1)


# Fix variable names. The initial ones had double quotes around them, so
# rename() would require escaping stuff. This is easier.

names(x) <- c("date", "target", "insult", "tweet")


# Remove missing rows. This keeps giving me warnings, but the warning message is
# always empty. Is this a bug?

x %<>%
  filter(is.na(tweet) == FALSE)


# Remove double quotes around strings and remove '-' in target
# variable. Also, remove ';' from end of and '.' from beginning of tweets.

x %<>%
  mutate(date = gsub('[\"]', '', date),
         target = gsub('[\"]', '', target),
         insult = gsub('[\"]', '', insult),
         tweet = gsub('[\"]', '', tweet),
         target = str_replace_all(target, '-', ' '),
         tweet = ifelse(substr(tweet, nchar(tweet), nchar(tweet)) == ';',
                         substr(tweet, 1, nchar(tweet)-1),
                        tweet),
         tweet = ifelse(substr(tweet, 1, 1) == '.',
                        substr(tweet, 2, nchar(tweet)),
                        tweet))


# Remove '.' from end of insult variable and one row where target is NA.

x %<>%
 mutate(insult = ifelse(substr(insult, nchar(insult), nchar(insult)) == '.',
                          substr(insult, 1, nchar(insult)-1),
                          insult)) %>%
  filter(is.na(target) == FALSE)


# Save data.

insults <- x

usethis::use_data(insults, overwrite = TRUE)




# OWN APPROACH: JUST NEED TO RUN THE CODE (TAKES ~18h).
#
# library(tidyverse)
# library(magrittr)
# library(janitor)
#
#
# # Reading in all tweets from Trump Twitter Archive. Tweets are from 2011 to
# # 2020.  I remove all retweets and all tweets where the original tweet text is
# # not available, but only some URL. I then select tweets (=text), favorites
# # (=likes) and date.
#
# x <- read_csv("data-raw/trump_tweets.csv") %>%
#       clean_names() %>%
#       filter(substr(text, 1, 5) != "https") %>%
#       filter(is_retweet == FALSE) %>%
#       select(text, favorites, date)
#
#
# Adding two new cols for target of insult and insult.
#
# cols <- tibble("target" = rep(NA_character_, nrow(x)),
#                "insult" = rep(NA_character_, nrow(x)))
#
# x <- cbind(x, cols)
#
#
# # We need a way to detect which of the tweets are insults, and if something is
# # an insult, who the target is. The NYT published a list of what they consider
# # insults, as well as the target. I just copied and pasted it into a
# # spreadsheet, so this still needs to be cleaned up first. The first step is to
# # remove all NAs.
#
# y <- read_delim("data-raw/insult_list.csv",
#                 delim = ";",
#                 escape_double = FALSE,
#                 trim_ws = TRUE) %>%
#      filter(is.na(insult) == FALSE)
#
#
# # The insults are in a single column named "raw", and it contains the target
# # (without quotes) and in all rows that follow the insults directed at that
# # target (in quotes). However, sometimes there is a second row without quotes
# # after a row with name of the target, explaining who this is. There is also a
# # second column named "target", which is still empty. The loop below assigns the
# # correct target to the "target" column, except for rows that are explanations,
# # where the target is replaced by NA_character. Since we don't need these
# # explanations,  we can then easily remove all of them afterwards by filtering
# # for non-NA rows in "target". I already did this manually in the csv file for
# # the first target, which was ABC News, since the -1 reference in the loop which
# # assigns NA_character to "target" for explanations does not work from a
# # starting value of 1. Therefore, the loop starts at row #19, which contains the
# # name of the second in the file target. IMPORTANT: I had to replace some
# # special character manually in the csv file as it would cause the loop to
# # return errors. We should revert this again at the end of this script. Here is
# # what I did: ? -> quesm, & -> amplm, } -> clbrk, and (stupidclbrk ->
# # stupidclbrk.
#
# for (i in 19:11746) {
#
#   if (substr(y$insult[i], 1, 1) != '\"') {
#
#     if (substr(y$insult[i-1], 1, 1) == '\"') {
#
#       target <- y$insult[i]
#       y$target[i] <- target
#
#     } else {
#
#       y$target[i] <- NA_character_
#
#     }
#
#   } else {
#
#     y$target[i] <- target
#
#   }
#
# }
#
# rm(i)
# rm(target)
#
#
# # As mentioned above, we can now remove all rows where target is NA, since these
# # are rows with an explanation only. Also get rid of rows with same entry, since
# # these are rows that were used to indicate the target for all actual insults
# # that followed (not needed anymore).
#
# y %<>%
#   filter(is.na(target) == FALSE,
#          insult != target)
#
#
# # The two first and last character in "insult" are a double quote, so we should
# # get rid of them.
#
# y %<>%
#   mutate(insult = substr(insult, 3, nchar(insult)-2))
#
#
# # Often, the last character is still a comma, a double quote, or a comma
# # followed by a double quote. Don't know why, but let's get rid of this too.
#
# y %<>%
#   mutate(insult = ifelse(substr(insult, nchar(insult), nchar(insult)) == ',',
#                          substr(insult, 1, nchar(insult)-1),
#                          insult),
#          insult = ifelse(substr(insult, nchar(insult), nchar(insult)) == '\"',
#                          substr(insult, 1, nchar(insult)-1),
#                          insult),
#          insult = ifelse(substr(insult, nchar(insult)-1, nchar(insult)) == ',\"',
#                          substr(insult, 1, nchar(insult)-2),
#                          insult))
#
#
# # Finally, we can now check whether which of the complete tweets in "x" have a
# # match with the insults in "y". If there is a match, the respective insult and
# # target from y should be assigned to the "insult" and "target" columns in x.
# # One thing to keep in mind here is that insults like "crooked" or "fake" have
# # likely been used for several people, to if there is a match, we also need to
# # make sure that the name of the target is contained in the tweet as well. When
# # checking for insults, cases matter, but not when checking for the name of the
# # target. I don't really know a good way to do this in a somewhat quick way. The
# # loop works, but it takes about 18h to run it.
#
# for (i in 128:45391) {
#
#   for (v in 1:10377)  {
#
#     if (str_detect(x$text[i], y$insult[v]) == TRUE) {
#
#       if (grepl(y$target[v], x$text[i], ignore.case = TRUE) == TRUE) {
#
#         x$insult[i] <- y$insult[v]
#         x$target[i] <- y$target[v]
#
#       } else {
#
#         x$insult[i] <- x$insult[i]
#         x$target[i] <- x$target[i]
#
#       }
#
#     } else {
#
#       x$insult[i] <- x$insult[i]
#       x$target[i] <- x$target[i]
#
#     }
#
#
#   }
#   print(i)
#
# }