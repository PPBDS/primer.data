# Script to include data from qscore database, credits to Aurash Vatan '23. The
# goal here is to get nicely accesible data on course names and their subsequent
# popularity. There's also maybe a few other variables we can look at.

# Three other potentially useful tables: "reviews" has the text of all the
# reviews in "classes", and "people" and "professors" together store the names
# of professors and which classes they taught. Some of the names used for
# columns may be slightly ambiguous, but hopefully that contributes some useful
# messiness to the data! There are a few more tables in the file, but they were
# purely for the functioning of the website and so are irrelevant.

# Required packages

library(dbplyr)
library(RSQLite)
library(usethis)
library(tidyverse)

# Create connection to DB

con <- DBI::dbConnect(RSQLite::SQLite(), "data-raw/info.db")

# Join people, professors, and classes table, save results, and disconnect.
# Handy to have this data saved as a "raw" dataset so that we don't have to
# re-download each time we change the wrangling in the main code block.

# The data is a little bit limited in the fact that courses with sections only
# have the main section displayed. This makes courses like Expos impossible to
# see section-level data -- and aggregate data isn't in this dataset across the
# sections.

res <- dbSendQuery(
  con,
  "Select
   *
  FROM
   (
      SELECT
         f.class_id,
         e.prof_name
      FROM
         people e
         JOIN
            professors f
            ON e.id = f.person_id
   )
   JOIN
      classes
      ON class_id = classes.id"
)

# Get raw data and then disconnect
raw <- dbFetch(res)
dbClearResult(res)
dbDisconnect(con)

# Rditing to create new tibble

x <- raw %>%

  # I removed all courses without a workload: the majority are dissertations or
  # workshops of some nature or another. None has an enrollment above 25. I also
  # removed all workloads that are listed as "N/A". None of them can be useful
  # to us.

  # I also got rid of all courses that don't have a term listed.

  filter(workload != "",
         workload != "N/A",
         !is.na(term)) %>%

  # Removing janky names from course_names (i.e. any name that appears after
  # Department ##: )

  mutate(
    course_number = as.character(map(
      map(
        course_number, ~ unlist(strsplit(., ":"))
      ), ~ .[1]
    ))
  ) %>%

  # We only need columns not for internal sql use

  select(-class_id, -id) %>%

  # Setting the columns to right variable types

  mutate(
    enrollment = as.integer(enrollment),
    overall = as.numeric(overall),
    workload = as.numeric(workload),
    department = as.character(department),
    term = as.character(term)
  ) %>%

  # Remove garbage courses. These are courses that are not like a "normal"
  # course.

  filter(!str_detect(course_name, "Direction of Doctoral")) %>%
  filter(!str_detect(course_name, "ECON 3000: TIME")) %>%

  # Only have one row for each course

  distinct(course_name, term, .keep_all = T) %>%

  # I kept department and number as separate variables, because I think it might
  # be interesting to see how Q scores vary across departments.

  # However, I removed the department and number from the name.

  mutate(
    course_name = as.character(map(
      map(
        course_name, ~ unlist(strsplit(., ":"))
      ), ~ .[2]
    ))
  ) %>%

  # Setting minimum threshold "N" for courses to show up & for us to only have
  # "lecture" style courses. I set this threshold at 15 for now.

  filter(enrollment > 15) %>%

  rename(rating = overall,
         hours = workload,
         instructor = prof_name) %>%

  # I don't know how much more helpful data from the Registrar would be.
  # Only additional information is enrollment breakdown by school, as well as
  # what the overarching department is.

  # DK: Should we merge in data from the Registrar?

  # https://registrar.fas.harvard.edu/faculty-staff/courses/enrollment/archived-course-enrollment-reports

  select(course_name, department, course_number, term, department,
         enrollment, hours, rating, instructor) %>%
  as_tibble() %>%


  # Removing whitespaces at the beginning of course names.

  mutate(course_name = str_trim(course_name)) %>%


  # Recoding term descriptions.

  mutate(term = str_replace(term, "S", "-Spring"),
         term = str_replace(term, "F", "-Fall")) %>%


  # Renaming variables.

  rename(name = "course_name",
         number = "course_number")


# Saving data.

qscores <- x

usethis::use_data(qscores, overwrite = TRUE)

