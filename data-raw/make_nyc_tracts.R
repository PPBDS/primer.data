# This is the file in which I save the code which allows for the creation, by
# hand, of the nyc_tracts.csv file, which is used in the second week of the
# bootcamp. It also includes some other stuff. It assumes that the current
# working directory is primer.data.


library(tidyverse)
library(tidycensus)
library(ggbeeswarm)

# This is take from: https://walker-data.com/census-r/exploring-us-census-data-with-visualization.html#ggbeeswarm

# The below is a bit hacky. But since the this data is used in the second week
# of classes, I wanted to make it as easy to handle as possible, with just three
# variables. Not sure about the year.

x <- get_acs(
  geography = "tract",
  state = "NY",
  county = c("New York", "Bronx", "Queens", "Richmond", "Kings"),
  variables = c(White = "B03002_003",
                Black = "B03002_004",
                Asian = "B03002_006",
                Hispanic = "B03002_012"),
  summary_var = "B19013_001",
  year = 2022
)

# Now that we have the data, we use (mostly) Walker's code to clean it.

z <- x |>
  group_by(GEOID) %>%
  filter(estimate == max(estimate, na.rm = TRUE)) %>%
  ungroup() %>%
  filter(estimate != 0) |>
  rename(tract = NAME, race = variable, population = estimate, med_income = summary_est) |>
  select(tract, race, med_income) |>
  arrange(tract)


write_csv(z, "data-raw/nyc_tracts.csv")

# That completes the process. Here is code which shows how we use the data. Just
# an FYI.

read_csv("data-raw/nyc_tracts.csv", show_col_types = FALSE) |>
  drop_na() |>
  ggplot(aes(x = race, y = med_income, color = med_income)) +
  geom_quasirandom(alpha = 0.5) +
  coord_flip() +
  theme_minimal(base_size = 13) +
  scale_color_viridis_c(guide = "none") +
  scale_y_continuous(labels = scales::label_dollar()) +
  labs(x = "Largest group in Census tract",
       y = "Median household income",
       title = "Household income distribution by largest racial/ethnic group",
       subtitle = "Census tracts, New York City",
       caption = "2022 American Community Survey")
