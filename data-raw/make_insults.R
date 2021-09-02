
library(tidyverse)
library(magrittr)
library(janitor)
library(parallel)
library(doParallel)
library(foreach)


# quesm amplm clbrk AND (stupidclbrk to stupidclbrk

# Reading in all tweets from Trump Twitter Archive. Tweets are from 2011 to
# 2020.  First, removing all retweets and all original tweets rows where the tweet
# text is not available, but only some URL. I then only keep tweets, favorites
# and date.

x <- read_csv("data-raw/trump_tweets.csv") %>%
      clean_names() %>%
      filter(substr(text, 1, 5) != "https") %>%
      filter(is_retweet == FALSE) %>%
      select(text, favorites, date)


# Adding two new cols for target of insult and insult.

cols <- tibble("target" = rep(NA_character_, nrow(x)),
               "insult" = rep(NA_character_, nrow(x)))

x <- cbind(x, cols)


# Read in insult list from NYTimes. I just copied and pasted it into a
# spreadsheet, so this still needs to be cleaned up first. Also, removing all
# NAs.

y <- read_delim("data-raw/insult_list.csv",
                delim = ";",
                escape_double = FALSE,
                trim_ws = TRUE) %>%
     filter(is.na(insult) == FALSE)


# The insults are in one column named "raw", and it contains the target (without
# quotes) and in all rows that follow the insults directed at that person (in
# quotes). However, sometimes there is a second row without quotes after the
# name of the target, explaining who this is. All rows will be assigned the
# correct target, expect for rows that are explanations, where the target is replaced by
# NA_character. I already did this manually in the csv file for the first
# target, since the -1 reference the remove explanation does not work from a
# starting value of 1. The next target starts at row #19.

for (i in 19:11746) {

  if (substr(y$insult[i], 1, 1) != '\"') {

    if (substr(y$insult[i-1], 1, 1) == '\"') {

      target <- y$insult[i]
      y$target[i] <- target

    } else {

      y$target[i] <- NA_character_

    }

  } else {

    y$target[i] <- target

  }

}

rm(i)
rm(target)


# Remove all rows where target is NA, since these are rows with an explanation
# only. Also get rid of rows with same entry, since these are rows that were
# used to indicate the name (not needed anymore).

y %<>%
  filter(is.na(target) == FALSE,
         insult != target)


# The two first and last character in "insult" are a ", so we should get rid of
# it.

y %<>%
  mutate(insult = substr(insult, 3, nchar(insult)-2))


# Often, the last character is still a comma. Don't know why, but this should
# not be there either.

y %<>%
  mutate(insult = ifelse(substr(insult, nchar(insult), nchar(insult)) == ',',
                         substr(insult, 1, nchar(insult)-1),
                         insult))


# I'm now checking whether any of these insults is contained in some of his
# tweets, and if so, I assign the insult and the target to the new columns. I
# guess there is a better way to do this, but I don't know how.


insult_vec <- paste(y$insult, collapse = "|")

x %<>%
  mutate(insult = str_extract(text, insult_vec))




numCores <- detectCores()-1
registerDoParallel(numCores)

for (i in 1:45391) {

  for(v in 1:10377) {

    if (str_detect(x$text[i], y$insult[v]) == TRUE) {

      if (grepl(y$target[v], x$text[i], ignore.case = TRUE) == TRUE) {

        x$insult[i] <- y$insult[v]
        x$target[i] <- y$target[v]

      } else {

        x$insult[i] <- x$insult[i]
        x$target[i] <- x$target[i]

      }

    } else {

      x$insult[i] <- x$insult[i]
      x$target[i] <- x$target[i]

    }


  }


}

