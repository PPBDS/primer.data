
library(tidyverse)
library(magrittr)
library(janitor)
library(jsonlite)


# Accessing data through Nobel Prize API. Last time run on 29.07.2021.

url <- "http://api.nobelprize.org/v1/laureate.json"
x <- fromJSON(url)


# This data comes as a list, so we need to convert it to a usable structure
# first.

x <- as_tibble(data.frame(x$laureates)) %>%
        clean_names() %>%
        select(-c(id, born_country_code, died_country_code)) %>%
        rename(first_name = firstname,
               last_name = surname)


# Extract variables from "prizes" list. I first created some new variables with
# empty values which will then be overwritten by the values in the list using
# the loop below.

new_cols <- tibble("year" = rep(NA_character_, 955),
                   "field" = rep(NA_character_, 955),
                   "share" = rep(NA_character_, 955),
                   "motivation" = rep(NA_character_, 955),
                   "aff_inst" = rep(NA_character_, 955),
                   "aff_city" = rep(NA_character_, 955),
                   "aff_country" = rep(NA_character_, 955))

x <- cbind(x, new_cols)

y <- tibble("first_name" = rep(NA_character_, 300),
                  "last_name" = rep(NA_character_, 300),
                  "born" = rep(NA_character_, 300),
                  "died" = rep(NA_character_, 300),
                  "born_country" = rep(NA_character_, 300),
                  "born_city" = rep(NA_character_, 300),
                  "died_country" = rep(NA_character_, 300),
                  "died_city" = rep(NA_character_, 300),
                  "gender" = rep(NA_character_, 300),
                  "prizes" = rep(NA_character_, 300),
                  "year" = rep(NA_character_, 300),
                  "field" = rep(NA_character_, 300),
                  "share" = rep(NA_character_, 300),
                  "motivation" = rep(NA_character_, 300),
                  "aff_inst" = rep(NA_character_, 300),
                  "aff_city" = rep(NA_character_, 300),
                  "aff_country" = rep(NA_character_, 300))

x <- rbind(x,y)


# City was missing for University of Delaware, which messes up the loop.

x[[10]][[826]][[5]][[1]][["city"]] <- "Newark, DE"


v <- 0
u <- -1

for (i in 1:955) {

    if (nrow(as_tibble(x[[10]][[i]])) == 1) {

    x$year[i] <- pull(x[[10]][[i]]["year"])
    x$field[i] <- pull(x[[10]][[i]]["category"])
    x$share[i] <- pull(x[[10]][[i]]["share"])
    x$motivation[i] <- pull(x[[10]][[i]]["motivation"])

      if (length(x[[10]][[i]][["affiliations"]][[1]][[1]]) == 0) {

      x$aff_inst[i] <- "None"
      x$aff_city[i] <- "None"
      x$aff_country[i] <- "None"

      } else {

        if (nrow(as_tibble(x[[10]][[i]][["affiliations"]][[1]])) == 1) {

          x$aff_inst[i] <- pull(x[[10]][[i]][["affiliations"]][[1]]["name"])
          x$aff_city[i] <- pull(x[[10]][[i]][["affiliations"]][[1]]["city"])
          x$aff_country[i] <- pull(x[[10]][[i]][["affiliations"]][[1]]["country"])

        } else {

        x$aff_inst[i] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[1]])[1, "name"], as_tibble(x[[10]][[i]][["affiliations"]][[1]])[2, "name"], sep = ", ")
        x$aff_city[i] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[1]])[1, "city"], as_tibble(x[[10]][[i]][["affiliations"]][[1]])[2, "city"], sep = ", ")
        x$aff_country[i] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[1]])[1, "country"], as_tibble(x[[10]][[i]][["affiliations"]][[1]])[2, "country"], sep = ", ")


        }
      }

    } else {

    for (v in 1:nrow(as_tibble(x[[10]][[i]]))) {

    u <- u + 1

    x$year[955 + u] <- pull(as_tibble(x[[10]][[i]])[v, "year"])
    x$field[955 + u] <- pull(as_tibble(x[[10]][[i]])[v, "category"])
    x$share[955 + u] <- pull(as_tibble(x[[10]][[i]])[v, "share"])
    x$motivation[955 + u] <- pull(as_tibble(x[[10]][[i]])[v, "motivation"])

    if (length(x[[10]][[i]][["affiliations"]][[v]][[1]]) == 0) {

      x$aff_inst[955 + u] <- "None"
      x$aff_city[955 + u] <- "None"
      x$aff_country[955 + u] <- "None"

      x$first_name[955 + u] <- x$first_name[i]
      x$last_name[955 + u] <- x$last_name[i]
      x$born[955 + u] <- x$born[i]
      x$died[955 + u] <- x$died[i]
      x$born_country[955 + u] <- x$born_country[i]
      x$born_city[955 + u] <- x$born_city[i]
      x$died_country[955 + u] <- x$died_country[i]
      x$died_city[955 + u] <- x$died_city[i]
      x$gender[955 + u] <- x$gender[i]

    } else {

      if (nrow(as_tibble(x[[10]][[i]][["affiliations"]][[v]])) == 1) {

      x$aff_inst[955 + u] <- pull(x[[10]][[i]][["affiliations"]][[v]]["name"])
      x$aff_city[955 + u] <- pull(x[[10]][[i]][["affiliations"]][[v]]["city"])
      x$aff_country[955 + u] <- pull(x[[10]][[i]][["affiliations"]][[v]]["country"])

      x$first_name[955 + u] <- x$first_name[i]
      x$last_name[955 + u] <- x$last_name[i]
      x$born[955 + u] <- x$born[i]
      x$died[955 + u] <- x$died[i]
      x$born_country[955 + u] <- x$born_country[i]
      x$born_city[955 + u] <- x$born_city[i]
      x$died_country[955 + u] <- x$died_country[i]
      x$died_city[955 + u] <- x$died_city[i]
      x$gender[955 + u] <- x$gender[i]

      } else {

      x$aff_inst[955 + u] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[v]])[1, "name"], as_tibble(x[[10]][[i]][["affiliations"]][[v]])[2, "name"], sep = ", ")
      x$aff_city[955 + u] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[v]])[1, "city"], as_tibble(x[[10]][[i]][["affiliations"]][[v]])[2, "city"], sep = ", ")
      x$aff_country[955 + u] <- paste(as_tibble(x[[10]][[i]][["affiliations"]][[v]])[1, "country"], as_tibble(x[[10]][[i]][["affiliations"]][[v]])[2, "country"], sep = ", ")

      x$first_name[955 + u] <- x$first_name[i]
      x$last_name[955 + u] <- x$last_name[i]
      x$born[955 + u] <- x$born[i]
      x$died[955 + u] <- x$died[i]
      x$born_country[955 + u] <- x$born_country[i]
      x$born_city[955 + u] <- x$born_city[i]
      x$died_country[955 + u] <- x$died_country[i]
      x$died_city[955 + u] <- x$died_city[i]
      x$gender[955 + u] <- x$gender[i]

      }
    }

    }
  }
}

# Convert to tibble and remove leftover NA-rows.

x %<>%
  tibble() %>%
  filter(is.na(field) == FALSE)


# Changing variable types and cleaning up.

x %<>%
  mutate(gender = str_to_title(gender),
         field = str_to_title(field),
         gender = as.factor(gender),
         field = as.factor(field),
         born = as.Date(born),
         died = as.Date(died),
         year = as.integer(year),
         share = as.integer(share),
         motivation = substr(motivation, 2, nchar(motivation)-1),
         born_country = str_replace(born_country, "Austria-Hungary (now Austria)", "Austria"),
         born_country = str_replace(born_country, "Austria-Hungary (now Bosnia and Herzegovina)", "Bosnia and Herzegovina"),
         born_country = str_replace(born_country, "Austria-Hungary (now Croatia)", "Croatia"),
         born_country = str_replace(born_country, "Austria-Hungary (now Czech Republic)", "Czechia"),
         born_country = str_replace(born_country, "Austria-Hungary (now Hungary)", "Hungary"),
         born_country = str_replace(born_country, "Austria-Hungary (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Austria-Hungary (now Slovenia)", "Slovenia"),
         born_country = str_replace(born_country, "Austria-Hungary (now Ukraine)", "Ukraine"),
         born_country = str_replace(born_country, "Austrian Empire (now Austria)", "Austria"),
         born_country = str_replace(born_country, "Austrian Empire (now Czech Republic)", "Czechia"),
         born_country = str_replace(born_country, "Austrian Empire (now Italy)", "Italy"),
         born_country = str_replace(born_country, "Bavaria (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Belgian Congo (now Democratic Republic of the Congo)", "D.R. Congo"),
         born_country = str_replace(born_country, "British India (now Bangladesh)", "Bangladesh"),
         born_country = str_replace(born_country, "British India (now India)", "India"),
         born_country = str_replace(born_country, "British Mandate of Palestine (now Israel)", "Israel"),
         born_country = str_replace(born_country, "British West Indies (now Saint Lucia)", "Saint Lucia"),
         born_country = str_replace(born_country, "Burma (now Myanmar)", "Myanmar"),
         born_country = str_replace(born_country, "Crete (now Greece)", "Greece"),
         born_country = str_replace(born_country, "Czechoslovakia (now Czech Republic)", "Czechia"),
         born_country = str_replace(born_country, "East Friesland (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Faroe Islands (Denmark)", "Denmark"),
         born_country = str_replace(born_country, "Free City of Danzig (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Faroe Islands (Denmark)", "Denmark"),
         born_country = str_replace(born_country, "French Algeria (now Algeria)", "Algeria"),
         born_country = str_replace(born_country, "German-occupied Poland (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Germany (now France)", "France"),
         born_country = str_replace(born_country, "Germany (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Germany (now Russia)", "Russia"),
         born_country = str_replace(born_country, "Gold Coast (now Ghana)", "Ghana"),
         born_country = str_replace(born_country, "Hesse-Kassel (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Hungary (now Slovakia)", "Slovakia"),
         born_country = str_replace(born_country, "India (now Pakistan)", "Pakistan"),
         born_country = str_replace(born_country, "Java, Dutch East Indies (now Indonesia)", "Indonesia"),
         born_country = str_replace(born_country, "Korea (now South Korea)", "South Korea"),
         born_country = str_replace(born_country, "Mecklenburg (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Ottoman Empire (now North Macedonia)", "North Macedonia"),
         born_country = str_replace(born_country, "Ottoman Empire (now Turkey)", "Turkey"),
         born_country = str_replace(born_country, "Persia (now Iran)", "Iran"),
         born_country = str_replace(born_country, "Poland (now Belarus)", "Belarus"),
         born_country = str_replace(born_country, "Poland (now Lithuania)", "Lithuania"),
         born_country = str_replace(born_country, "Poland (now Ukraine)", "Ukraine"),
         born_country = str_replace(born_country, "Prussia (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Prussia (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Prussia (now Russia)", "Russia"),
         born_country = str_replace(born_country, "Russian Empire (now Azerbaijan)", "Azerbaijan"),
         born_country = str_replace(born_country, "Russian Empire (now Belarus)", "Belarus"),
         born_country = str_replace(born_country, "Russian Empire (now Finland)", "Finland"),
         born_country = str_replace(born_country, "Russian Empire (now Lithuania)", "Lithuania"),
         born_country = str_replace(born_country, "Russian Empire (now Russia)", "Russia"),
         born_country = str_replace(born_country, "Russian Empire (now Latvia)", "Latvia"),
         born_country = str_replace(born_country, "Russian Empire (now Poland)", "Poland"),
         born_country = str_replace(born_country, "Russian Empire (now Ukraine)", "Ukraine"),
         born_country = str_replace(born_country, "Schleswig (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Southern Rhodesia (now Zimbabwe)", "Zimbabwe"),
         born_country = str_replace(born_country, "Tibet (now China)", "China"),
         born_country = str_replace(born_country, "Tuscany (now Italy)", "Italy"),
         born_country = str_replace(born_country, "USSR (now Belarus)", "Belarus"),
         born_country = str_replace(born_country, "USSR (now Russia)", "Russia"),
         born_country = str_replace(born_country, "West Germany (now Germany)", "Germany"),
         born_country = str_replace(born_country, "Württemberg (now Germany)", "Germany"),
         born_country = str_replace(born_country, "the Netherlands", "Netherlands"))


# Arrange.

x %<>%
  arrange(field, year)


# Sort variables and remove useless stuff.

x %<>%
  select(-prizes, -aff_country) %>%
  select(1:2, year, field, share, gender, everything())


# Save.

nobel <- x

usethis::use_data(nobel, overwrite = T)




